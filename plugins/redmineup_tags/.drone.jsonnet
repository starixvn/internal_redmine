local Pipeline(rubyVer, db, license, redmine, dependents) = {
  kind: "pipeline",
  name: rubyVer + "-" + db + "-" + redmine + "-" + license + "-" + dependents,
  steps: [
    {
      name: "tests",
      image: "redmineup/redmineup_ci",
      commands: [
        "service postgresql start && service mysql start && sleep 5",
        "export PATH=~/.rbenv/shims:$PATH",
        "export CODEPATH=`pwd`",
        "/root/run_for.sh redmineup_tags+" + license + " ruby-" + rubyVer + " " + db + " redmine-" + redmine + " " + dependents
      ]
    }
  ]
};

[
  Pipeline("3.1.0", "pg", "pro", "trunk", ""),
  Pipeline("3.1.0", "mysql", "pro", "trunk", "redmine_agile+pro"),
  Pipeline("3.1.0", "mysql", "light", "trunk", "redmine_agile+light"),
  Pipeline("3.1.0", "pg", "pro", "5.0", ""),
  Pipeline("2.7.3", "mysql", "pro", "4.2", ""),
  Pipeline("2.7.3", "pg", "light", "4.2", ""),
  Pipeline("2.4.1", "mysql", "light", "4.0", ""),
  Pipeline("2.4.1", "pg", "pro", "3.4", "redmine_contacts+pro"),
  Pipeline("2.2.6", "pg", "light", "3.4", ""),
  Pipeline("2.2.6", "mysql", "pro", "3.0", "")
]
