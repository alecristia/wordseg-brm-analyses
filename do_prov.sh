#!/bin/bash
#segment independent transcripts

# where to read the tags files
input_dir="/scratch2/acristia/wsexp/Providence"

# where to write results (erase any content if the directory already exist)
output_dir="/scratch2/mbernard/experiments/wsexp/results_do_prov"
rm -rf $output_dir

# wordseg tool to launch segmentation pipelines on the cluster
wordseg_slurm="/shared/apps/wordseg/tools/wordseg-slurm.sh"

# the token separators in the tags files
separator="-p' ' -s';esyll' -w';eword'"


# get the list of tags files in the input_dir
all_tags="$input_dir/*tags.txt"
ntags=$(echo $all_tags | wc -w)
echo "found $ntags tags files in $input_dir"

# temporary jobs file to list all the wordseg jobs to execute
jobs=$(mktemp)
trap "rm -rf $jobs" EXIT

# build the list of wordseg jobs from the list of tags files
counter=1
for tags in $all_tags
do
    name=$(basename $tags | cut -d- -f1)
    echo -n "[$counter/$ntags] building jobs for $name ..."

    for unit in syllable phone
    do
        # common to all commands
        header="$tags $unit $separator"

        # defines segmentation jobs
        echo "$name-$unit-baseline-00 $header wordseg-baseline -v -P 0" >> $jobs
        echo "$name-$unit-baseline-05 $header wordseg-baseline -v -P 0.5" >> $jobs
        echo "$name-$unit-baseline-10 $header wordseg-baseline -v -P 1" >> $jobs
        echo "$name-$unit-tprel $header wordseg-tp -v -t relative" >> $jobs
        echo "$name-$unit-tpabs $header wordseg-tp -v -t absolute" >> $jobs
        echo "$name-$unit-dibs $header wordseg-dibs -v -t phrasal -u $unit $tags" >> $jobs
        echo "$name-$unit-puddle $header wordseg-puddle -v -j 5 -w 2" >> $jobs
        echo "$name-$unit-ag $header wordseg-ag -vv -j 8" >> $jobs
    done

    ((counter++))
    echo " done"

    # # for testing, process only some tags
    # [ $counter -eq 4 ] && break
done


# load the wordseg python environment
module load anaconda/3
source activate /shared/apps/anaconda3/envs/wordseg

# launching all the jobs
echo -n "submitting $(cat $jobs | wc -l) jobs ..."
$wordseg_slurm $jobs $output_dir > /dev/null
echo " done"

echo "all jobs submitted, writing to $output_dir"
echo "view status with 'squeue -u $USER'"

# unload the environment
source deactivate

exit 0
