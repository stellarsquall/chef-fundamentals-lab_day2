# Apache Lab
## Chef Fundamentals

In this lab exercise you'll test everything you've learned so far about Chef!

## Getting setup

_This lab should be completed within the CentOS 7 training environment provided by your instructor._

* Log in to the CentOS machine using an SSH client. In most cases your terminal or PowerShell should have SSH available.
  * Ask the instructor for connection details if needed.
  * You'll need to select a text editor to modify files with. 
   * These editors are preinstalled, or you can install your own:
     * vi/vim
     * emacs
     * nano
   * If you've never used one of these editors, nano is recommended. Try it out by opening a file:
     * `nano hello.txt`
   * You should see a commands list across the bottom of the screen. Make some changes, and then save the file with cntl+o , or exit the editor with cntl+x , which will ask if you would like to save your changes.
   * Print your file contents to check your work with `cat hello.txt`

## A simple apache webserver

_Try to complete the lab by following the steps. If you get stuck, ask your neighbor or call the instructor over. Check the solution if you have any issues or are having trouble with the code._

1. Create a cookbooks directory in /home/chef/

2. Generate a new cookbook called "apache" in the cookbook directory

3. Generate a recipe called "server" in the apache cookbook

4. Populate the server recipe with three resources:
   * the `package` resource should install the apache package, named "httpd" on rhel systems
   * the `file` resource should create "/var/www/html/index.html" with the content `<h1>Hello, world!</h1>`
   * the `service` resource should enable and start the "httpd" service

5. Use the `include_recipe` method to call the server recipe by default.

6. Execute the default recipe with the chef-client.
   * Don't forget about:
     * `--local-mode` or `-z`
     * `--runlist` or `-r`
     * We're on a *nix system, we need to have `sudo` privilages!

7. Verify that the chef-client completes as expected and your webpage is being served on the localhost
   * Execute `curl localhost`
   * What are some other ways could you check your work?