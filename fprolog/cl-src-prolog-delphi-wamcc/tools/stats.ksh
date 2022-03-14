
cat pentbook_debug.trace$1 | grep oracles

cat pentbook_debug.trace$1 | grep 'sol(' | wc -l

cat pentbook_debug.trace$1 | grep 'sol(' | sort | uniq | wc -l

cat pentbook_debug.trace$1 | grep completed
