require 'sinatra'
require 'json'
require 'git'

post '/payload' do
	push = JSON.parse(request.body.read)
	puts "I got some JSON"

	github_url =  push["repository"]["url"] +'.git'
	clone_cmd = "git clone " + github_url
	p github_url
	p clone_cmd

	commit = push["after"]
	checkout_cmd = "git checkout " + commit
	p commit
	p checkout_cmd

	repo_name = push["repository"]["name"]
	p repo_name
	cmd = "cd " + repo_name + "/ci_fuzzing " + "; timeout 1m ./fuzz_test.sh ; gh issue create -l bug -t 'fuzzing commit#" + commit + "' -b 'BUG FOUND'"
	p cmd

	Git.clone(github_url, repo_name)
	fork{exec(cmd)}

end
