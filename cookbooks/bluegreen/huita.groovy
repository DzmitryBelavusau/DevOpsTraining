def command = "knife environment list -F json -c /home/user/share/chef-repo/.chef/knife.rb"
def proc = command.execute()
proc.waitFor()
def roles = []
roles = "${proc.in.text}" .eachLine { line ->
    roles << line
}
return roles