# ----------------------------------------------------
#  #  tagを生成する
# ----------------------------------------------------
#
#  # 言語
# see also `ctags --list-languages`
lang := C \
HTML \
Java \
JavaScript \
Perl \
PHP \
Python \
Ruby \
SQL

lower_lang := $(shell echo $(lang) | tr A-Z a-z)

# 各言語のtag対象ファイルの拡張子
# see also `ctags --list-maps`
ext := default       \
	.rb.ruby.spec \
	default       \
	default

TARGET_PATH  = $(PWD)  # ここは基本的に書き換える
git_toplevel = $(shell cd $(TARGET_PATH);git rev-parse --show-toplevel)
seq          = $(shell seq 1 $(words $(lang)))

ifeq ($(git_toplevel),)
	# gitリポジトリ管理ではない場合
	tags_save_dir = $(realpath $(TARGET_PATH))/tags
	tags_target_dir = $(realpath $(TARGET_PATH))
else
	# gitリポジトリ管理である場合
	tags_save_dir = $(HOME)/dotfiles/tags_files/$(shell basename $(git_toplevel))
	tags_target_dir = $(git_toplevel)
endif

.PHONY: create_tags $(seq)

create_tags: $(seq)

$(seq):
	mkdir -p $(tags_save_dir)
	ctags -R \
		--languages=$(word $@,$(lang)) \
		--langmap=$(word $@,$(lang)):$(word $@,$(ext)) \
		-f $(tags_save_dir)/$(word $@,$(lower_lang))_tags $(tags_target_dir)
