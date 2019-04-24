# Introducing Test-Kitchen
## Chef Fundamentals

This lab exercise will be guided by your instructor. 

## Getting setup

_This lab should be completed within the CentOS 7 training environment provided by your instructor._

* The required template file for test kitchen is included in this repo and should also be present within the home directory of your training environment at:
  * /home/chef/kitchen-template.yml
* This file should be copied into the cookbook you'd like to test, replacing the generated .kitchen.yml that is created by the `chef generate cookbook` command.
  * For example, overwrite the apache kitchen template in your apache cookbook:
    * `cd ~`
    * `cp kitchen-template.yml cookbooks/apache/.kitchen.yml`
      * notice that when copied the new file must be prefixed by a `.`
   * The template file has a placeholder under the `suites` section for COOKBOOK_NAME . In this example it should be replaced with `apache`