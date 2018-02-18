#!/usr/bin/env bash
data=tac2017
scriptdir=$PWD

mkdir -p ../../data/$data/intermediate
mkdir -p ../../data/$data/results

echo 'generating entityCounts.txt'
python3 entityCounts.py $data

echo 'generating eid-feature counts & strength files'
python3 extractFeatures.py $data

echo 'skipgram features'
python3 TFIDFSelection.py $data Skipgram

echo 'type feature'
python3 TFIDFSelection.py $data Type

echo 'generating embedding files using word2vec'
python3 prepareFormatForEmbed_word2vec.py $data

cd ../tools/word2vec/src
make

cd ../
chmod +x ./run.sh
./run.sh $data

cd $scriptdir
python3 getEmbFile.py $data word2vec
