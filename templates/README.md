# Templates Lab Exercise
## Chef Fundamentals

Here we discuss generating template files and utilizing ERB syntax, aka embedded Ruby.

## Templates for better file management

_This exercise will be guided by your instructor. Check out the [About Templates](https://docs.chef.io/templates.html) docs as you follow along._

* Log in to the Centos 7 machine using your ssh client.
  * Ask the instructor for connection details if needed.

## Generating a template

1. Navigate into the home directory with `cd ~`

2. Generate a template file within the apache cookbook.
   * Check the generator options with --help.
   * The NAME of the template is the name of the file we're replacing, index.html for the apache cookbook:
   * `chef generate template cookbooks/apache index.html`
   * Check out the resulting file tree:
   ```
    ~/cookbooks/apache/
    ├── Berksfile
    ├── CHANGELOG.md
    ├── LICENSE
    ├── README.md
    ├── chefignore
    ├── metadata.rb
    ├── recipes
    │   ├── default.rb
    │   └── server.rb
    ├── spec
    │   ├── spec_helper.rb
    │   └── unit
    │       └── recipes
    │           ├── default_spec.rb
    │           └── server_spec.rb
    ├── templates
    │   └── index.html.erb
    └── test
        └── integration
            └── default
                ├── default_test.rb
                └── server_test.rb
   ```

## Embedded Ruby

3. Notice the directory called templates/ and the index.html.erb file it contains.
   * Embedded Ruby (ERB) is a templating language commonly utilized by Ruby developers. It allows us to pass variables (often Node Attributes) into a templating file that should be rendered by the chef-client when it runs.
   * The [template resource](https://docs.chef.io/resource_template.html) has a source property that points to the erb file and renders any of the Ruby code found inside. [Variables](https://docs.chef.io/templates.html#variables) can also be passed directly from the template resource definition within a recipe.

4. ERB sytax is very simple.
   * There are two basic types of tags:
     * `<% %>`
     * `<%= %>`
   * The first tag evaluates the Ruby code within the tag, but does not print the result.
   * The second tag both evaluates and prints the result.
   * To print a node attribute, we simply wrap the attribute in the second tag, like so:
     * `<%= node['ATTRIBUTE'] %>`

5. To use a template instead of the file resource, two changes need to occur:
   1) Generate an ERB file and define the template code
   2) Use the template resource instead of file

## Using ERB

6. Defining the ERB
   * From the apache cookbook's server recipe, copy the content of the index.html file we previously defined. Paste this content into index.html.erb
   * Next, replace any string interpolated values with the ERB syntax. For example, transform
     * `#{ node['ipaddress'] }`
     into
     * `<%= node['ipaddress'] %>`
   Notice we do **not** need the `#{}` anymore, because we're not inside of a string. We're using ERB instead!

7. Call the template from the recipe
   * Next, we want to use a template resource instead of the file resource:
   a) Opening the server recipe, change file to template
   b) Erase the `content` property, and replace it with a `source` that resolves to the name of the file in the templates directory, 'index.html.erb'
   ```
   template '/var/www/html/index.html' do
     source 'index.html.erb'
   end
   ```
   * Save your recipe and your template, and you're ready to test.

8. execute, verify, version
   * Finally, execute the chef-client
     * You must use the --runlist option here. If you attempt to simply run the recipe by providing the apache/recipes/server.rb path, the chef-client won't be able to locate your template file.
   * Verify the webserver made the changes.
     * How can you tell? Did anything change?
     * How did the output of chef-client change?
   * Version the apache cookbook
     * Semantic versioning uses major.minor.patch
     * What type of change did we make?
       * Hint: did you change the behavior of the webserver?
         * major: backwards-incompatible
         * minor: functional change
         * patch: bug fix, refactor, documentation