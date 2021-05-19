#!/bin/bash
#SBATCH -p short -N 1 -n 16 --mem 16gb --out phmmer_1job.log
module load hmmer/3

curl -o HMG_box.hmm http://pfam.xfam.org/family/PF00505/hmm

ln -s /bigdata/stajichlab/shared/projects/Chytrid/Chytrid_Phylogenomics/Phylogeny/pep .
cat pep/*.fasta > allseqs.aa
esl-sfetch --index allseqs.aa
hmmsearch --domtbl HMG.hits.domtbl -E 1e-5 HMG_box.hmm allseqs.aa > HMG_box.hmmsearch
grep -h -v '^#' HMG.hits.domtbl | awk '{print $1}' | sort | uniq | esl-sfetch -f allseqs.aa - > HMG.hits.aa.fa # Extraction of the hits to a file
grep ">" HMG.hits.aa.fa | cut -d\| -f1 | sed 's/>//' | sort | uniq -c > HMG.hit.counts.txt
