# ==================================================================================
#
# This software is provided TO YOU without any warranty, guarantee, or liability
# resulting in use, misuse, abuse or distribution.
#
# YOU ARE FREE TO COPY, DISTRIBUTE OR MODIFY THIS CODE FREE OF CHARGE, PENALTY,
# OR DONATION PROVIDED THE FOLLOWING CONDITIONS ARE MET:
#
#  1) DO NOT REMOVE OR MODIFY THE PRECEDING NOTICE.
#  2) DO NOT REMOVE OR MODIFY THE FOLLOWING NOTICE.
#
    MAKESTATS := $(info MakeStats (C) 2014 Triston J. Taylor All Rights Reserved.) \
    $(info                                                                       )
#
# ==================================================================================
#
# You may modify the license in any way you wish provided the following conditions
# are met:
#
#  1) You obtain written permission from <pc.wiz.tt@gmail.com>.
#  2) You make a contribution of $5.00 or more to support the ORIGINAL works of THIS
#     copyright holder.
#
# PayPal: via e-mail or via web
# https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=DG3H6F8DSG4BC
#
# ==================================================================================
#    Please indicate "MakeStats" as your purpose and provide ANY contact address.
# ==================================================================================

# Usage

# To use this file properly, you must include the file at the end
# of your make script, or at least after the default rule.

INIT_STATS != if ! test -e make.sts; then \
	echo Creating build statistics database ... >&2; \
	echo 0 0 0 0 `date +%s` $(USER) `basename $(shell pwd)` > make.sts; \
fi;

BUILD_STATS != cat make.sts 2>&- || true
BUILD_MAJOR = $(word 1, $(BUILD_STATS))
BUILD_MINOR = $(word 2, $(BUILD_STATS))
BUILD_REVISION = $(word 3, $(BUILD_STATS))
BUILD_NUMBER = $(word 4, $(BUILD_STATS))
BUILD_DATE = $(word 5, $(BUILD_STATS))
BUILD_USER  = $(word 6, $(BUILD_STATS))
BUILD_NAME = $(wordlist 7, $(words $(BUILD_STATS)), $(BUILD_STATS))

THIS_BUILD_REVISION != expr $(BUILD_REVISION) + 1
THIS_BUILD_NUMBER != expr $(BUILD_NUMBER) + 1
THIS_BUILD_DATE != date +%s

push-stats = echo -n \
$(BUILD_MAJOR) $(BUILD_MINOR) $(THIS_BUILD_REVISION) $(THIS_BUILD_NUMBER)  \
$(THIS_BUILD_DATE) $(USER) $(BUILD_NAME) > make.sts;

push-major: BUILD_MAJOR = $(shell expr $(BUILD_MINOR) + 1)
push-major: BUILD_MINOR = 0
push-major: THIS_BUILD_REVISION = 0
push-major: THIS_BUILD_NUMBER = $(BUILD_NUMBER)
push-major: THIS_BUILD_DATE = $(BUILD_DATE)
push-major:
	@$(push-stats)
	@echo

push-minor: BUILD_MINOR = $(shell expr $(BUILD_MINOR) + 1)
push-minor: THIS_BUILD_REVISION = 0
push-minor: THIS_BUILD_NUMBER = $(BUILD_NUMBER)
push-minor: THIS_BUILD_DATE = $(BUILD_DATE)
push-minor:
	@$(push-stats)
	@echo

code-name: THIS_BUILD_NUMBER = $(BUILD_NUMBER)
code-name: THIS_BUILD_REVISION = $(BUILD_REVISION)
code-name: THIS_BUILD_DATE = $(BUILD_DATE)
code-name:
	@$(shell read -ep "Enter product or code name: " NAME; echo \
		$(BUILD_MAJOR) $(BUILD_MINOR) $(THIS_BUILD_REVISION) $(THIS_BUILD_NUMBER)  \
		$(THIS_BUILD_DATE) $(USER) $$NAME > make.sts; \
	)

stats:
	@echo Build Developer: $(BUILD_USER)
	@echo '  'Build Version: $(BUILD_MAJOR).$(BUILD_MINOR).$(BUILD_REVISION)
	@echo '   'Build Number: $(BUILD_NUMBER)
	@echo '     'Build Date: `date --date=@$(BUILD_DATE)`
	@echo '     'Build Name: $(BUILD_NAME)
	@echo

