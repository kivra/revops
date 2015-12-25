PROJECT = revops

# Dependecies ##########################################################
DEPS = meck

dep_meck = git git@github.com:kivra/meck.git 0.8.2

# Standard targets #####################################################
include erlang.mk
