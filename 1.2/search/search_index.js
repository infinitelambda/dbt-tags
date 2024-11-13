var __index = {"config":{"lang":["en"],"separator":"[\\s\\-,:!=\\[\\]()\"`/]+|\\.(?!\\d)|&[lg]t;|(?!\\b)(?=[A-Z][a-z])","pipeline":["stopWordFilter"]},"docs":[{"location":"index.html","title":"\ud83d\udce6 Overview","text":""},{"location":"index.html#dbt-tags","title":"dbt-tags","text":"<p>Tag-based masking policies management in Snowflake \u2744\ufe0f \ud83c\udff7\ufe0f</p> <p>Who is this for?</p> <p>For the dbt-ers who want:</p> <ul> <li>To manage \u2744\ufe0f Object Tagging within the dbt project using dbt tags (column level)</li> <li>To manage \u2744\ufe0f Dynamic Data Masking following the Tag-based approach</li> </ul>"},{"location":"index.html#installation","title":"Installation","text":"<ul> <li>Add to <code>packages.yml</code> file:</li> </ul> <pre><code>packages:\n  - package: infinitelambda/dbt_tags\n    version: [\"&gt;=1.0.0\", \"&lt;1.1.0\"]\n</code></pre> <p>Or use the latest version from git:</p> <pre><code>packages:\n  - git: \"https://github.com/infinitelambda/dbt-tags\"\n    revision: &lt;release version or tag&gt;\n</code></pre> <p>And run <code>dbt deps</code> to install the package!</p>"},{"location":"index.html#quick-demo","title":"Quick Demo","text":"<p>Jump into Getting Started page for more details on how to start using this package.</p> <p>\ud83d\udcf9 Here is a quick live demo:</p> <p>Quick run through dbt-tags package - Watch Video</p>"},{"location":"index.html#variables","title":"Variables","text":"<p>See <code>dbt_project.yml</code> file</p> <p>Go to <code>vars</code> section here \ud83c\udfc3</p> <p>We managed to provide the inline comments only for now, soon to have the dedicated page for more detail explanation.</p> <p>Here are the full list of built-in variables:</p> <ul> <li><code>dbt_tags__database</code></li> <li><code>dbt_tags__schema</code></li> <li><code>dbt_tags__allowed_tags</code></li> <li><code>dbt_tags__resource_types</code></li> <li><code>dbt_tags__policy_data_types</code></li> <li><code>dbt_tags__tag_source_columns</code></li> </ul>"},{"location":"index.html#how-to-contribute","title":"How to Contribute \u2764\ufe0f","text":"<p><code>dbt-tags</code> is an open-source dbt package. Whether you are a seasoned open-source contributor or a first-time committer, we welcome and encourage you to contribute code, documentation, ideas, or problem statements to this project.</p> <p>\ud83d\udc49 See CONTRIBUTING guideline for more details or check out CONTRIBUTING.md</p> <p>\ud83c\udf1f And then, kudos to our beloved Contributors:</p> <p> </p>"},{"location":"index.html#about-infinite-lambda","title":"About Infinite Lambda","text":"<p>Infinite Lambda is a cloud and data consultancy. We build strategies, help organizations implement them, and pass on the expertise to look after the infrastructure.</p> <p>We are an Elite Snowflake Partner, a Platinum dbt Partner, and a two-time Fivetran Innovation Partner of the Year for EMEA.</p> <p>Naturally, we love exploring innovative solutions and sharing knowledge, so go ahead and:</p> <p>\ud83d\udd27 Take a look around our Git</p> <p>\u270f\ufe0f Browse our tech blog</p> <p>We are also chatty, so:</p> <p>\ud83d\udc40 Follow us on LinkedIn</p> <p>\ud83d\udc4b\ud83c\udffc Or just get in touch</p> <p></p>"},{"location":"contributing.html","title":"Contributing to <code>dbt-tags</code>","text":"<p><code>dbt-tags</code> is open-source dbt package \u2764\ufe0f. Whether you are a seasoned open-source contributor or a first-time committer, we welcome and encourage you to contribute code, documentation, ideas, or problem statements to this project.</p> <ul> <li>Contributing to <code>dbt-tags</code></li> <li>About this document</li> <li>Getting the code<ul> <li>Installing git</li> <li>External contributors</li> </ul> </li> <li>Setting up an environment<ul> <li>Tools</li> <li>Get dbt profile ready</li> </ul> </li> <li>Linting</li> <li>Testing</li> <li>Committing</li> <li>Submitting a Pull Request</li> </ul>"},{"location":"contributing.html#about-this-document","title":"About this document","text":"<p>There are many ways to contribute to the ongoing development of <code>dbt-tags</code>, such as by participating in discussions and issues.</p> <p>The rest of this document serves as a more granular guide for contributing code changes to <code>dbt-tags</code> (this repository). It is not intended as a guide for using <code>dbt-tags</code>, and some pieces assume a level of familiarity with Python development with <code>poetry</code>. Specific code snippets in this guide assume you are using macOS or Linux and are comfortable with the command line.</p> <ul> <li>Branches: All pull requests from community contributors should target the <code>main</code> branch (default). If the change is needed as a patch for a minor version of dbt that has already been released (or is already a release candidate), a maintainer will backport the changes in your PR to the relevant \"latest\" release branch (<code>1.0.&lt;latest&gt;</code>, <code>1.1.&lt;latest&gt;</code>, ...). If an issue fix applies to a release branch, that fix should be first committed to the development branch and then to the release branch (rarely release-branch fixes may not apply to <code>main</code>).</li> <li>Releases: Before releasing a new minor version, we prepare a series of beta release candidates to allow users to test the new version in live environments. This is an important quality assurance step, as it exposes the new code to a wide variety of complicated deployments and can surface bugs before official release. Releases are accessible via pip.</li> </ul>"},{"location":"contributing.html#getting-the-code","title":"Getting the code","text":""},{"location":"contributing.html#installing-git","title":"Installing git","text":"<p>You will need <code>git</code> in order to download and modify the <code>dbt-tags</code> source code. On macOS, the best way to download git is to just install Xcode.</p>"},{"location":"contributing.html#external-contributors","title":"External contributors","text":"<p>You can contribute to <code>dbt-tags</code> by forking the <code>dbt-tags</code> repository. For a detailed overview on forking, check out the GitHub docs on forking. In short, you will need to:</p> <ol> <li>Fork the <code>dbt-tags</code> repository</li> <li>Clone your fork locally</li> <li>Check out a new branch for your proposed changes</li> <li>Push changes to your fork</li> <li>Open a pull request against <code>infintelambda/dbt-tags</code> from your forked repository</li> </ol>"},{"location":"contributing.html#setting-up-an-environment","title":"Setting up an environment","text":"<p>There are some tools that will be helpful to you in developing locally. While this is the list relevant for <code>dbt-tags</code> development, many of these tools are used commonly across open-source python projects.</p>"},{"location":"contributing.html#tools","title":"Tools","text":"<p>We will buy <code>poetry</code> in <code>dbt-tags</code> development and testing.</p> <p>So first install poetry via pip or via the official installer, please help to check right version used in poetry.lock file. Then, start installing the local environment:</p> <pre><code>poetry install\npoetry shell\npoe git-hooks\n</code></pre> <p>\u2139\ufe0f If you receive an error on poetry install when trying to install dbt-tags, create an empty file <code>dbt-tags</code> in the root directory and try again, this should fix the issue.</p>"},{"location":"contributing.html#get-dbt-profile-ready","title":"Get dbt profile ready","text":"<p>Please help to check the sample script to initialize Snowflake environment in <code>integration_tests/ci</code> directory, and get your database freshly created.</p> <p>Next, you should follow dbt profile instruction and setting up your dedicated profile. Again, you could try our sample in the same above directory.</p> <p>Run <code>poe dbt-tags-verify</code> for verifying the connection \u2705</p>"},{"location":"contributing.html#linting","title":"Linting","text":"<p>We're trying to also maintain the code quality leveraging sqlfluff.</p> <p>It is highly encouraged that you format the code before commiting using the below <code>poe</code> helpers:</p> <pre><code>poe lint    # check your code, we run this check in CI\npoe format  # format your code to match sqlfluff configs\n</code></pre>"},{"location":"contributing.html#testing","title":"Testing","text":"<p>Once you're able to manually test that your code change is working as expected, it's important to run existing automated tests, as well as adding some new ones. These tests will ensure that:</p> <ul> <li>Your code changes do not unexpectedly break other established functionality</li> <li>Your code changes can handle all known edge cases</li> <li>The functionality you're adding will keep working in the future</li> </ul> <p>See here for details for running existing integration tests and adding new ones:</p> <p>An integration test typically involves making 1) a new seed file 2) a new model file 3) a generic test to assert anticipated behaviour.</p> <p>Once you've added all of these files, in the <code>poetry shell</code>, you should be able to run:</p> <p>\u2139\ufe0f If you are using Windows OS, make sure that you Developer Mode activated on your machine. This is so that symlinks can be created by the command line when installing the main <code>dbt-tags</code> project into the <code>integration_tests</code> sub-project. If it is not enabled, it will go into an endless loop of installing the packages inside each other over and over again until you run out of HD space.</p> <p>\u2139\ufe0f If you get an error when running the below due to a conflict when it is trying to run <code>dbt deps</code> from within <code>integration_tests</code> when using vs code, then this is likely due to a conflict with one or more extensions. Either disable extensions in vs code, such as dbt power user, or you can close vs code and run <code>dbt deps</code> directly from a command prompt window once you've cd'd into the correct folder.</p> <pre><code>poe dbt-tags-test\n</code></pre>"},{"location":"contributing.html#committing","title":"Committing","text":"<p>Upon running <code>poe git-hooks</code> we will make sure that you provide as the clean &amp; neat commit messages as possible.</p> <p>There are 2 main checks:</p> <ul> <li>Trailing whitespace: If any, it will try to fix it for us, and we have to stage the changes before committing</li> <li>Commit message: It must follow the commitizen convention as <code>{change_type}: {message}</code></li> <li><code>change_type</code>: is one of <code>feat|fix|chore|refactor|perf|BREAKING CHANGE</code></li> </ul>"},{"location":"contributing.html#submitting-a-pull-request","title":"Submitting a Pull Request","text":"<p>Code can be merged into the current development branch <code>main</code> by opening a pull request. A <code>dbt-tags</code> maintainer will review your PR. They may suggest code revision for style or clarity, or request that you add unit or integration test(s). These are good things! We believe that, with a little bit of help, anyone can contribute high-quality code.</p> <p>Automated tests run via GitHub Actions. If you're a first-time contributor, all tests (including code checks and unit tests) will require a maintainer to approve. Changes in the <code>dbt-tags</code> repository trigger integration tests against Snowflake \ud83d\udcb0.</p> <p>Once all tests are passing and your PR has been approved, a <code>dbt-tags</code> maintainer will merge your changes into the active development branch. And that's it!</p> <p>Happy Developing \ud83c\udf89</p>"},{"location":"getting-started.html","title":"Getting Started with <code>dbt-tags</code> package","text":"<p>In order to start the Tag-based masking journey in our dbt project, we have 6 essential steps as follows:</p> <p>Notes</p> <ul> <li>Before diving into steps, it's recommended to learn more on Tag-based masking polcies (skip if you knew it already \ud83d\udcaf)</li> <li>Also, please be noted that you will need the Snowflake Enterprise Edition as the prerequisite</li> </ul> <p>Now, let's go \ud83c\udfc3:</p>"},{"location":"getting-started.html#1-configure-the-namespace-databse-schema","title":"1. Configure the namespace (databse, schema)","text":"<p>Firstly, we should let dbt know where we would like to store the Tag objects (as well as the Masking Policies' definitions).</p> <p>We'll put the <code>dbt_tags</code>'s variables in <code>dbt_project.yml</code> file as below:</p> <pre><code>vars:\n  # dbt_tags__database: MY_DB # (optional) default to `target.database` if not specified\n  dbt_tags__schema: COMMON # (optional) default to `target.schema` if not specified\n</code></pre>"},{"location":"getting-started.html#2-decide-to-allow-the-specific-tags-only","title":"2. Decide to allow the specific tags only","text":"<p>\u2139\ufe0f Skip this step if all dbt tags are allowed. Otherwise, see the sample below:</p> <pre><code>vars:\n  dbt_tags__allowed_tags:\n    - pii_name\n    - pii_email\n    - ...\n</code></pre>"},{"location":"getting-started.html#3-decide-to-commit-masking-policies-definition","title":"3. Decide to commit masking policies' definition","text":"<p>\u2139\ufe0f Skip this step if you decide not to use masking policies, but only tags!</p> <p>Masking Policies' functions vary depending on the dbt project, so it's your responsibility to implement them in advance.</p> <p>In the dbt root directory, let's create a new one within <code>/macros</code> folder e.g. <code>/macros/mp-ddl</code>.</p> <p>For each tag name, we need a corresponding macro that holds the masking policy definition.</p> <p>Given a sample, we have a tag named <code>pii_name</code>, we'll create a macro file as below:</p> <pre><code>-- File path: /macros/mp-ddl/create_masking_policy__pii_name.sql\n{% macro create_masking_policy__pii_name(ns) -%}\n\n  create masking policy if not exists {{ ns }}.pii_name as (val string)\n    returns string -&gt;\n    case --/ your definition start here /--\n      when is_role_in_session('ROLE_HAS_PII_ACCESS') then val\n      else sha2(val)\n    end;\n\n{%- endmacro %}\n</code></pre> <p><code>{{ ns }}</code> or <code>ns</code> stands for the schema namespace, let's copy the same!</p> <p>\u2139\ufe0f If you want to have multiple masking policies of different data types (they must be different data types) to a single tag, follow these steps:</p> <p>Given a sample, we have a tag named <code>pii_null</code>, we'll create a macro file as below:</p> <pre><code>-- File path: /macros/mp-ddl/create_masking_policy__pii_null.sql\n{% macro create_masking_policy__pii_null(ns) -%}\n\n  create masking policy if not exists {{ ns }}.pii_null_varchar as (val string)\n    returns string -&gt;\n    case --/ your definition start here /--\n      when is_role_in_session('ROLE_HAS_PII_ACCESS') then val\n      else null\n    end;\n\n  create masking policy if not exists {{ ns }}.pii_null_number as (val number)\n    returns number -&gt;\n    case --/ your definition start here /--\n      when is_role_in_session('ROLE_HAS_PII_ACCESS') then val\n      else null\n    end;\n\n{%- endmacro %}\n</code></pre> <p>We then must modify the optional var <code>dbt_tags__policy_data_types</code> in the <code>dbt_project.yml</code> file:</p> <pre><code>vars:\n  dbt_tags__policy_data_types:\n    - pii_null: ['varchar','number']\n</code></pre> <p>These must match the exact same data_type suffix that has been applied to the name of the masking policies in the create macro. This will then assign both of these to the single tag, rather than having to manage multiple of the same tag for the different data types.</p> <p>Leaving any tags out of the <code>dbt_tags__policy_data_types</code> var definition means that it will expect only a single masking policy which has the exact same name as the tag.</p>"},{"location":"getting-started.html#4-set-tags-on-columns","title":"4. Set tags on columns","text":"<p>To assign tags to columns, you follow the same process as you would apply dbt tags to columns normally. This is done in the model schema yaml files.</p> <p>By default, this package assigns the name of the column as the value of the tag. Because of how dbt tags work, there is no out of the box way to assign values for the Snowflake tags, so a separator (\"~\") has been configured within <code>dbt_tags</code> to facilitate this.</p> <p>Setting a value for a tag can be useful for Security Governance querying in Snowflake. Or it can be used within a masking policy to allow some dynamic functionality using the Snowflake function <code>system$get_tag_on_current_column('fully.qualified.tag-name')</code>.</p> <p>Looking at a model's schema yaml file:</p> <ul> <li>If you don't need a tag value</li> </ul> <pre><code>columns:\n    - name: first_name\n      description: Customer's first name. PII.\n      tags:\n        - pii_name\n</code></pre> <ul> <li>If you do need a tag value</li> </ul> <pre><code>columns:\n    - name: membership_number\n      description: Customer's membership number. PII.\n      tags:\n        - pii_mask_last_x_characters~4\n</code></pre> <p>The value is then available to use either in the masking policy or in Snowflake.</p> <p>\u2139\ufe0f <code>dbt tags</code> will only deploy tags that have been set on columns. If you have tags or masking policies which aren't assigned to columns, they won't be deployed.</p>"},{"location":"getting-started.html#5-deploy-resources-tags-masking-policies","title":"5. Deploy resources (tags, masking policies)","text":"<p>\u2757We don't want to repeat this step on every dbt run(s).</p> <p>Instead, let's do it as a step in the Production Release process (or manually).</p> <p>Remove <code>--args '{debug: true}'</code> for a live run</p> <ul> <li>Deploy the <code>dbt tags</code> to DWH:</li> </ul> <pre><code>dbt run-operation create_tags --args '{debug: true}'\n</code></pre> <ul> <li>Deploy the tag-based masking policy functions to DWH:</li> </ul> <p>\u2139\ufe0f Skip this step if you decide not to use masking policies, but only tags!</p> <pre><code>dbt run-operation create_masking_policies --args '{debug: true}'\n</code></pre>"},{"location":"getting-started.html#6-apply-tags-to-columns","title":"6. Apply tags to columns","text":"<p>\u2139\ufe0f Currently, only column tags are supported!</p> <p>Add a new <code>post-hook</code> to the model level:</p> <pre><code>models:\n  my_project:\n    post-hook:\n      - &gt; # customize below `if` condition following your need\n        {% if flags.WHICH in ('run', 'build') %}\n          {{ dbt_tags.apply_column_tags() }}\n        {% endif %}\n</code></pre>"},{"location":"getting-started.html#7-apply-masking-policies-to-tags","title":"7. Apply masking policies to tags","text":"<p>\u2139\ufe0f Skip this step if you decide not to use masking policies, but only tags!</p> <p>Remove <code>--args '{debug: true}'</code> for a live run</p> <pre><code>dbt run-operation apply_mps_to_tags --args '{debug: true}'\n</code></pre> <p>Now, go to Snowflake and check the result! \ud83d\ude80</p> <p>Happy Masking \ud83c\udf89</p>"},{"location":"util-drop-tag.html","title":"Decide to Drop the Object Tags","text":"<p><code>dbt-tags</code> supports a macro to help us to clean up the DWH Object Tags which might be redundant or accidentally created:</p> <p><code>drop_tags</code> (source)</p>"},{"location":"util-drop-tag.html#usage","title":"Usage","text":"<pre><code>dbt run-opertion drop_tags [--args '{debug: true}']\n</code></pre> <p>See doc in yml</p>"},{"location":"util-drop-tag.html#how-does-it-work","title":"How does it work?","text":"<p>For example, you'd like to drop tags that were wrongly created in the schema named <code>analytics.demo</code>.</p> <p>Let's run the command below:</p> <pre><code>dbt run-opertion drop_tags \\\n  --vars '{dbt_tags__database: analytics, dbt_tags__schema: demo}'\n</code></pre> <ul> <li>It scans all the Object Tags that were created in <code>analytics.demo</code> schema. Behind the scene script is:</li> </ul> <pre><code>show tags in schema analytics.demo;\nselect  \"database_name\" || '.' || \"schema_name\" || '.' || \"name\" as tag_name\nfrom    table(result_scan(last_query_id()))\nwhere   \"database_name\" || '.' || \"schema_name\" ilike 'analytics.demo';\n</code></pre> <ul> <li>If exists any tags:</li> <li> <p>For each object tag:</p> <ul> <li>Check if there are multiple datatypes for the associated masking policy</li> <li>Unset masking policy(ies) from the tag</li> <li>Drop the tag</li> </ul> </li> <li> <p>Done!</p> </li> </ul> <p>Note this will currently only drop masking policies which are assigned to the tags via the <code>dbt_tags</code> package. If you have manually assigned a masking policy to the tag, it will currently not unset it before trying to drop, and will fail.</p>"},{"location":"util-unset-masking-policy.html","title":"Decide to Unset Masking Policies","text":"<p><code>dbt-tags</code> supports a macro to help us to perform Unset Masking Policy operation (1) from the Object Tags easily for a clean up purpose. Please note that we shouldn't run it (1) prior to Set Masking Policy operation (2) because we always run (2) with Force.</p> <p><code>unapply_mps_from_tags</code> (source)</p>"},{"location":"util-unset-masking-policy.html#usage","title":"Usage","text":"<pre><code>dbt run-operation unapply_mps_from_tags [\\\n  --args '{ns: \"database.schema\", debug: true}']\n</code></pre> <p>See doc in yml</p>"},{"location":"util-unset-masking-policy.html#how-does-it-work","title":"How does it work?","text":"<p>For example, you'd like to Unset Masking Policy from the tags that were created in the schema named <code>analytics.demo</code>.</p> <p>Let's run the command below:</p> <pre><code>dbt run-opertion unapply_mps_from_tags \\\n  --vars '{ns: \"analytics.demo\"}'\n</code></pre> <ul> <li> <p>It scans all the Object Tags that were created in <code>analytics.demo</code> schema. Behind the scene script is:</p> <pre><code>show tags in schema analytics.demo;\nselect  \"database_name\" || '.' || \"schema_name\" || '.' || \"name\" as tag_name\nfrom    table(result_scan(last_query_id()))\nwhere   \"database_name\" || '.' || \"schema_name\" ilike 'analytics.demo';\n</code></pre> </li> <li> <p>If exists any tags:</p> </li> <li> <p>Checks if masking policy has multiple data types</p> <ul> <li>Unset masking policy from tag with</li> </ul> </li> <li> <p>Done!</p> </li> </ul>"}]}