#!/bin/sh

# =============================================================================

temp_clean_branch='m/master'

# =============================================================================

	echo clean ........
	# --------------------------------------------
	echo Git Clean Started $(date) ........
	git clean -d -f
	git reset --hard HEAD
	git checkout "$temp_clean_branch"
	echo Git Clean Completed $(date) ........
	# --------------------------------------------

# =============================================================================

echo " "
echo "The End."

# =============================================================================