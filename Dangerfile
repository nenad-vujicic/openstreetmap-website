# Remove all previously added labels
auto_label.remove("Big PR")
auto_label.remove("Compromised Translations")
auto_label.remove("Merge Commits")
auto_label.remove("Good PR")

# Report if number of changed lines is > 500
pr_number = github.pr_json["number"]
is_big_pr = git.lines_of_code > 500
warn("Number of updated lines of code is too large to be in one PR. Perhaps it should be separated into two or more?") if is_big_pr
auto_label.set(pr_number, "Big PR", "ffff00") if is_big_pr

# Get list of translation files (except en.yml) which are modified
modified_yml_files = git.modified_files.select do |file|
  file.start_with?("config/locales") && File.extname(file) == ".yml" && File.basename(file) != "en.yml"
end

# Report if some translation file (except en.yml) is modified
unless modified_yml_files.empty?
  modified_files_str = modified_yml_files.map { |file| "`#{file}`" }.join(", ")
  warn("The following YAML files other than `en.yml` have been modified: #{modified_files_str}. Only `en.yml` is allowed to be changed.")
  auto_label.set(pr_number, "Compromised Translations", "ff0000")
end

# Report if there are merge-commits in PR
are_merge_commits_available = git.commits.any? { |c| c.parents.count > 1 }
warn("Merge commits found in this pull request. Please, read CONTRIBUTE.md!") if are_merge_commits_available
auto_label.set(pr_number, "Merge Commits", "ffaec9") if are_merge_commits_available

# Report "Everything is fine!" if no warnings were generated
message("Everything is fine!") if !is_big_pr && modified_yml_files.empty? && !are_merge_commits_available
auto_label.set(pr_number, "Good PR", "00ff00") if !is_big_pr && modified_yml_files.empty? && !are_merge_commits_available
