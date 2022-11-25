#! /usr/bin/env ruby
# frozen_string_literal: true

ADDED_OR_MODIFIED = /^\s*(A|AM|M)/.freeze

changed_files = `git status --porcelain`.split(/\n/)
unstaged_files = `git ls-files -m`.split(/\n/)

changed_files = changed_files.select { |f| f =~ ADDED_OR_MODIFIED }
changed_files = changed_files.map { |f| f.split(' ')[1] }

changed_files -= (unstaged_files - changed_files)

changed_files = changed_files.select { |file_name| File.extname(file_name) == '.rb' && !file_name.include?('schema') }
changed_files = changed_files.join(' ')

exit(0) if changed_files.empty?

success = system(%(
  rubocop #{changed_files}
))

STDIN.reopen('/dev/tty')

exit(1) if success == false
