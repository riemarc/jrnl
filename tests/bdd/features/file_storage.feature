Feature: Journals iteracting with the file system in a way that users can see

    Scenario: Adding entries to a Folder journal should generate date files
        Given we use the config "empty_folder.yaml"
        When we run "jrnl 23 July 2013: Testing folder journal."
        Then we should see the message "Entry added"
        And the journal directory should contain
            2013/07/23.txt

    Scenario: Adding multiple entries to a Folder journal should generate multiple date files
        Given we use the config "empty_folder.yaml"
        When we run "jrnl 23 July 2013: Testing folder journal."
        And we run "jrnl 3/7/2014: Second entry of journal."
        Then we should see the message "Entry added"
        And the journal directory should contain
            2013/07/23.txt

    Scenario: If the journal and its parent directory don't exist, they should be created
        Given we use the config "missing_directory.yaml"
        Then the journal should not exist
        When we run "jrnl This is a new entry in my journal"
        Then the journal should exist
        When we run "jrnl -99 --short"
        Then the output should contain "This is a new entry in my journal"

    Scenario: If the journal file doesn't exist, then it should be created
        Given we use the config "missing_journal.yaml"
        Then the journal should not exist
        When we run "jrnl This is a new entry in my journal"
        Then the journal should exist
        When we run "jrnl -99 --short"
        Then the output should contain "This is a new entry in my journal"

    Scenario: Creating journal with relative path should update to absolute path
        When we run "jrnl hello world" and enter
            test.txt
            n
        Then the output should contain "Journal 'default' created"
        When we change directory to "subfolder"
        And we run "jrnl -n 1"
        Then the output should contain "hello world"

    Scenario: the temporary filename suffix should default to ".jrnl"
        Given we use the config "editor.yaml"
        When we run "jrnl --edit"
        Then the editor should have been called
        Then the editor filename should end with ".jrnl"

    Scenario: the temporary filename suffix should be "-{template_filename}"
        Given we use the config "editor_markdown_extension.yaml"
        When we run "jrnl --edit"
        Then the editor filename should end with "-extension.md"
