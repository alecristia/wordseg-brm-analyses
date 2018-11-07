#!/bin/bash
#create and analyzed concatenated versions

# where to read the tags files
input_dir="/scratch2/acristia/wsexp/Providence"

# the childs to consider in this experiment
childs="eth lil nai vio wil"

# where to write results (erase any content if the directory already exist)
output_dir="/scratch2/mbernard/experiments/wsexp/results_do_concat_prov"
rm -rf $output_dir

# wordseg tool to launch segmentation pipelines on the cluster
wordseg_slurm="/shared/apps/wordseg/tools/wordseg-slurm.sh"

# the token separators in the tags files
separator="-p' ' -s';esyll' -w';eword'"


# temporary directory to store intermediate files
tempdir=$(mktemp -d)
trap "rm -rf $tempdir" EXIT

# temporary jobs file to list all the wordseg jobs to execute
jobs=$tempdir/jobs.txt


for child in $childs
do
    mkdir -p $tempdir/$child
    concat_tags=$tempdir/$child/concat_tags.txt
    concat_record=$tempdir/$child/concat_record.txt

    # all tags from this child
    echo -n "building jobs for child $child ..."
    all_tags="$input_dir/${child}*tags.txt"
    ntags=$(echo $all_tags | wc -w)

    counter=1
    for tags in $all_tags
    do
        name=$child-$counter

        # add this transcript to the concatenation
        cat $tags >> $concat_tags
        echo $tags >> $concat_record

        # make a subdir for this concatenation
        cp $concat_tags $tempdir/$child/${counter}_tags.txt

        for unit in syllable phone
        do
            # common to all commands
            header="$tempdir/$child/${counter}_tags.txt $unit $separator"

            # defines segmentation jobs
            echo "$name-$unit-baseline-00 $header wordseg-baseline -P 0" >> $jobs
            echo "$name-$unit-baseline-05 $header wordseg-baseline -P 0.5" >> $jobs
            echo "$name-$unit-baseline-10 $header wordseg-baseline -P 1" >> $jobs
            echo "$name-$unit-tprel $header wordseg-tp -t relative" >> $jobs
            echo "$name-$unit-tpabs $header wordseg-tp -t absolute" >> $jobs
            echo "$name-$unit-dibs $header wordseg-dibs -t phrasal -u $unit $tempdir/$child/${counter}_tags.txt" >> $jobs
            echo "$name-$unit-puddle $header wordseg-puddle -j 5 -w 2" >> $jobs
            echo "$name-$unit-ag $header wordseg-ag -j 8 -vv" >> $jobs
        done

        ((counter++))

        # # for testing, process only 2 tags per child
        # [ $counter -eq 3 ] && break
    done
    echo " done"
done

# load the wordseg python environment
module load anaconda/3
source activate /shared/apps/anaconda3/envs/wordseg

# launching all the jobs
echo -n "submitting $(cat $jobs | wc -l) jobs ..."
$wordseg_slurm $jobs $output_dir > /dev/null
echo " done"

echo -n "saving concat_record for each child ..."
for child in $childs
do
    cp $tempdir/$child/concat_record.txt $output_dir/${child}_concat_record.txt
done
echo " done"

echo "all jobs submitted, writing to $output_dir"
echo "view status with 'squeue -u $USER'"

# unload the environment
source deactivate

exit 0
