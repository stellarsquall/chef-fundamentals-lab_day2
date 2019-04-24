# Ohai Lab Exercise
## Chef Fundamentals

Here we discuss Ohai, the system profiling tool used by the chef-client, and how to use the "node attributes" it collects within recipes and resources.

## Ohai, welcome!

_In this module you will run the ohai tool directly, view it's output, and learn about executing various plugins._

* Log in to the CentOS 7 machine using your SSH client.
  * Ask the instructor for connection details if needed.

1. From the home directory, run `ohai`
   * The ChefDK is a collection of Ruby Gems (libraries) that collectively allow you to generate Chef policy and interact with a Chef Server. Once of these tools is called [Ohai](https://docs.chef.io/ohai.html)
   * This was the first Chef tool written! It collects host details when run and presents them in a JSON format.

2. Ohai is composed of plugins
   * Each top-level key in the output is an ohai "plugin"
   * Plugins can be selectively executed to see just that output.
   * Try it out:
     * `ohai platform`
     * `ohai ipaddress`
     * `ohai network`
     * `ohai memory`
     * `ohai languages`
   * Some plugins contain other sub-plugins, or nested keys. These can be accessed by adding a slash after the parent plugin:
     * `ohai memory/total`
     * `ohai cpu/0`
     * `ohai cpu/0/mhz`
     * `ohai languages/perl`
   * Check out a list of the [default plugins](https://docs.chef.io/ohai.html#default-plugins)

3. In addition to the built-in plugins, community plugins can be installed, or you can write your own
   * The [Community Plugins](https://docs.chef.io/plugin_community.html#ohai) page displays special plugins for certain hardware, platforms, and organization of output.
   * You can also write your own [Custom Ohai Plugin](https://docs.chef.io/ohai_custom.html). There is a special DSL for this, just like when writing recipes. These can be difficult for anyone new to Ruby, so check out the community plugins before you dive into writing your own.

4. The chef-client uses Ohai to build the Node Object
   * Although Ohai is included with the ChefDK, you don't need to run it manually. The chef-client does this for you at the beginning of each run. 
   * The chef-client uses this information to build the base of the [Node Object](https://docs.chef.io/nodes.html#node-objects).
   * This object is globally-accessible to the run, meaning that it can be accessed by your recipes and resources. The key-value pairs we saw before are called **Node Attributes**, and are one of the most important concepts to master. 

## Utilizing the Node Object

5. Node Attributes as tunables
   * An **attribute** is simply a piece of information about your node. This information can be accessed by a recipe or resource during the course of the chef-client run. At the end of the run, the information is persisted to a Chef Server or when in local-mode to the ~/nodes/ directory. 
     * Check it out now - you should see a file in c:\users\administrator\nodes named after the internal hostname (you will need to use sudo privilages to do so). This contains the node object from the previous run! 
   * The [About Attributes](https://docs.chef.io/attributes.html) documentation states that attributes are used to determine:
     * The current state of the node
     * What the state of the node was at the end of the previous chef-client run
     * What the state of the node should be at the end of the current chef-client run

5. Hello, attribute
   * To see attributes in action, let's add one to our apache webserver.
   * Open the server recipe, and examine the file resource:
   ```
   file '/var/www/html/index.html' do
     content '<h1>Hello, world!</h1>'
   end
   ```
   * Remember the syntax for a node attribute:
     * `node['ATTRIBUTE']`
     * `node['PARENT_ATTRIBUTE']['CHILD_ATTRIBUTE']`
   * We would like to add an attribute to the `content` property of the file resource, but you'll notice this doesn't work as expected if you simply copy-paste:
   ```
   file '/var/www/html/index.html' do
     content '<h1>Hello, world!</h1>
     node['ATTRIBUTE']
     '
   end
   ```
   * The single quotes define a "static" string, meaning that it's printing plain text to the file. The chef-client won't recognize any variables within the single quotes of the content property.
   * Another problem is that this code won't compile correctly due to the single quotes found in the node attribute, terminating the "content" string too early.
   * We can fix this easily by replacing the single quotes with double quotes around the content property:
   ```
   file '/var/www/html/index.html' do
     content "<h1>Hello, world!</h1>
     node['ATTRIBUTE']
     "
   end
   ```
   * Our code will now compile but it's still considered a string, which is static content. The ouput would literally print node['ATTRIBUTE'] , not the attribute's value itself.
   * We use **string interpolation** to solve this issue. This method allows us to insert a variable, or object defined outside of a string into the static content. The syntax rules are:
     * Use "double-quotes" around any string you're inserting an attribute or Ruby variable into
     * surround the attribute with #{}
     * ex. "#{ node['ATTRIBUTE'] }"
   * Our example now looks like this:
   ```
   file '/var/www/html/index.html' do
     content "<h1>Hello, world!</h1>
     #{node['ATTRIBUTE']}
     "
   end
   ```

6. Print some other attributes
   * Use string interpolation to add the following attributes to your Hello, world page:
     * platform
     * ipaddress
     * memory/total
     * cpu/0/mhz

## Extending the Node Object

7. User-defined attributes
   * Node Attributes can also be created from other policy, such as:
     * Cookbooks (in attribute files and/or recipes)
     * Roles
     * Environments
   * Within a cookbook, attributes are often defined to provide tunable values that can be passed to recipe files. These might include configuration data that is prone to changing across different platforms or that needs to be updated through time, such as:
     * package names and version
     * paths to config files
     * variables to be passed to templates
   * It's important to note that automatic attributes (those collected by Ohai) cannot be overwritten by a user-defined attribute. Meaning, you cannot overwrite an attribute like ipaddress, or memory/total. Automatic attributes must be modified with an Ohai plugin, or if necessary can be disabled.
   * Discussion:
     * What is is the Node Object, and how is it different from Ohai?
     * What are the differences between user-defined attributes, and attributes gathered by Ohai?
     * Why can't attributes created by Ohai be overwritten? When might you want to overwrite them?
