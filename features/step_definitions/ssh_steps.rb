


When /^I execute ncc\-sync "([^"]*)"$/ do |arg1|
    $sshout = ""
    $sshout = `ssh -l root -o StrictHostKeyChecking=no $TESTHOST sm-ncc-sync #{arg1}`
    if ! $?.success?
        raise "Execute command failed: #{$!}: #{$sshout}"
    end
end

Then /^I want to get "([^"]*)"$/ do |arg1|
    found = false
    $sshout.each_line() do |line|
        if line.include?(arg1)
            found = true
            break
        end
    end
    if not found
        raise "'#{arg1}' not found in output '#{$sshout}'"
    end
end
