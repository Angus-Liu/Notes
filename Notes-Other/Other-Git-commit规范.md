# Git commit日志基本规范

> 参考：
>
> - [Commit message 和Change log 编写指南- 阮一峰的网络日志](http://www.ruanyifeng.com/blog/2016/01/commit_message_change_log.html)
>
> - [Git写出好的 commit message](https://ruby-china.org/topics/15737) 

```properties
<type>(<scope>): <subject>
<BLANK LINE>
<body>
<BLANK LINE>
<footer>
```

对格式的说明如下：

type 代表某次提交的类型，比如是修复一个bug还是增加一个新的feature。所有的type类型如下：

- feat: 新增feature
- fix: 修复bug
- docs: 仅仅修改了文档，比如README, CHANGELOG, CONTRIBUTE等等
- style: 仅仅修改了空格、格式缩进等等，不改变代码逻辑
- refactor: 代码重构，没有加新功能或者修复bug
- perf: 优化相关，比如提升性能、体验
- test: 测试用例，包括单元测试、集成测试等
- chore: 改变构建流程、或者增加依赖库、工具等
- revert: 回滚到上一个版本



> <https://github.com/angular/angular/blob/master/CONTRIBUTING.md>

# Contributing to Angular

We would love for you to contribute to Angular and help make it even better than it is today! As a contributor, here are the guidelines we would like you to follow:

- [Code of Conduct](https://github.com/angular/angular/blob/master/CONTRIBUTING.md#coc)
- [Question or Problem?](https://github.com/angular/angular/blob/master/CONTRIBUTING.md#question)
- [Issues and Bugs](https://github.com/angular/angular/blob/master/CONTRIBUTING.md#issue)
- [Feature Requests](https://github.com/angular/angular/blob/master/CONTRIBUTING.md#feature)
- [Submission Guidelines](https://github.com/angular/angular/blob/master/CONTRIBUTING.md#submit)
- [Coding Rules](https://github.com/angular/angular/blob/master/CONTRIBUTING.md#rules)
- [Commit Message Guidelines](https://github.com/angular/angular/blob/master/CONTRIBUTING.md#commit)
- [Signing the CLA](https://github.com/angular/angular/blob/master/CONTRIBUTING.md#cla)

## Code of Conduct

Help us keep Angular open and inclusive. Please read and follow our [Code of Conduct](https://github.com/angular/code-of-conduct/blob/master/CODE_OF_CONDUCT.md).

## Got a Question or Problem?

Do not open issues for general support questions as we want to keep GitHub issues for bug reports and feature requests. You've got much better chances of getting your question answered on [Stack Overflow](https://stackoverflow.com/questions/tagged/angular) where the questions should be tagged with tag `angular`.

Stack Overflow is a much better place to ask questions since:

- there are thousands of people willing to help on Stack Overflow
- questions and answers stay available for public viewing so your question / answer might help someone else
- Stack Overflow's voting system assures that the best answers are prominently visible.

To save your and our time, we will systematically close all issues that are requests for general support and redirect people to Stack Overflow.

If you would like to chat about the question in real-time, you can reach out via [our gitter channel](https://gitter.im/angular/angular).

## Found a Bug?

If you find a bug in the source code, you can help us by [submitting an issue](https://github.com/angular/angular/blob/master/CONTRIBUTING.md#submit-issue) to our [GitHub Repository](https://github.com/angular/angular). Even better, you can[submit a Pull Request](https://github.com/angular/angular/blob/master/CONTRIBUTING.md#submit-pr) with a fix.

## Missing a Feature?

You can *request* a new feature by [submitting an issue](https://github.com/angular/angular/blob/master/CONTRIBUTING.md#submit-issue) to our GitHub Repository. If you would like to *implement* a new feature, please submit an issue with a proposal for your work first, to be sure that we can use it. Please consider what kind of change it is:

- For a **Major Feature**, first open an issue and outline your proposal so that it can be discussed. This will also allow us to better coordinate our efforts, prevent duplication of work, and help you to craft the change so that it is successfully accepted into the project.
- **Small Features** can be crafted and directly [submitted as a Pull Request](https://github.com/angular/angular/blob/master/CONTRIBUTING.md#submit-pr).

## Submission Guidelines

### Submitting an Issue

Before you submit an issue, please search the issue tracker, maybe an issue for your problem already exists and the discussion might inform you of workarounds readily available.

We want to fix all the issues as soon as possible, but before fixing a bug we need to reproduce and confirm it. In order to reproduce bugs, we will systematically ask you to provide a minimal reproduction. Having a minimal reproducible scenario gives us a wealth of important information without going back & forth to you with additional questions.

A minimal reproduction allows us to quickly confirm a bug (or point out a coding problem) as well as confirm that we are fixing the right problem.

We will be insisting on a minimal reproduction scenario in order to save maintainers time and ultimately be able to fix more bugs. Interestingly, from our experience users often find coding problems themselves while preparing a minimal reproduction. We understand that sometimes it might be hard to extract essential bits of code from a larger code-base but we really need to isolate the problem before we can fix it.

Unfortunately, we are not able to investigate / fix bugs without a minimal reproduction, so if we don't hear back from you we are going to close an issue that doesn't have enough info to be reproduced.

You can file new issues by selecting from our [new issue templates](https://github.com/angular/angular/issues/new/choose) and filling out the issue template.

### Submitting a Pull Request (PR)

Before you submit your Pull Request (PR) consider the following guidelines:

1. Search [GitHub](https://github.com/angular/angular/pulls) for an open or closed PR that relates to your submission. You don't want to duplicate effort.

2. Be sure that an issue describes the problem you're fixing, or documents the design for the feature you'd like to add. Discussing the design up front helps to ensure that we're ready to accept your work.

3. Please sign our [Contributor License Agreement (CLA)](https://github.com/angular/angular/blob/master/CONTRIBUTING.md#cla) before sending PRs. We cannot accept code without this. Make sure you sign with the primary email address of the Git identity that has been granted access to the Angular repository.

4. Fork the angular/angular repo.

5. Make your changes in a new git branch:

   ```
   git checkout -b my-fix-branch master
   ```

6. Create your patch, **including appropriate test cases**.

7. Follow our [Coding Rules](https://github.com/angular/angular/blob/master/CONTRIBUTING.md#rules).

8. Run the full Angular test suite, as described in the [developer documentation](https://github.com/angular/angular/blob/master/docs/DEVELOPER.md), and ensure that all tests pass.

9. Commit your changes using a descriptive commit message that follows our [commit message conventions](https://github.com/angular/angular/blob/master/CONTRIBUTING.md#commit). Adherence to these conventions is necessary because release notes are automatically generated from these messages.

   ```
   git commit -a
   ```

   Note: the optional commit `-a` command line option will automatically "add" and "rm" edited files.

10. Push your branch to GitHub:

    ```
    git push origin my-fix-branch
    ```

11. In GitHub, send a pull request to `angular:master`.

- If we suggest changes then:

  - Make the required updates.

  - Re-run the Angular test suites to ensure tests are still passing.

  - Rebase your branch and force push to your GitHub repository (this will update your Pull Request):

    ```
    git rebase master -i
    git push -f
    ```

That's it! Thank you for your contribution!

#### After your pull request is merged

After your pull request is merged, you can safely delete your branch and pull the changes from the main (upstream) repository:

- Delete the remote branch on GitHub either through the GitHub web UI or your local shell as follows:

  ```
  git push origin --delete my-fix-branch
  ```

- Check out the master branch:

  ```
  git checkout master -f
  ```

- Delete the local branch:

  ```
  git branch -D my-fix-branch
  ```

- Update your master with the latest upstream version:

  ```
  git pull --ff upstream master
  ```

## Coding Rules

To ensure consistency throughout the source code, keep these rules in mind as you are working:

- All features or bug fixes **must be tested** by one or more specs (unit-tests).
- All public API methods **must be documented**. (Details TBC).
- We follow [Google's JavaScript Style Guide](https://google.github.io/styleguide/jsguide.html), but wrap all code at **100 characters**. An automated formatter is available, see [DEVELOPER.md](https://github.com/angular/angular/blob/master/docs/DEVELOPER.md#clang-format).

## Commit Message Guidelines

We have very precise rules over how our git commit messages can be formatted. This leads to **more readable messages**that are easy to follow when looking through the **project history**. But also, we use the git commit messages to **generate the Angular change log**.

### Commit Message Format

Each commit message consists of a **header**, a **body** and a **footer**. The header has a special format that includes a **type**, a **scope** and a **subject**:

```
<type>(<scope>): <subject>
<BLANK LINE>
<body>
<BLANK LINE>
<footer>
```

The **header** is mandatory and the **scope** of the header is optional.

Any line of the commit message cannot be longer 100 characters! This allows the message to be easier to read on GitHub as well as in various git tools.

The footer should contain a [closing reference to an issue](https://help.github.com/articles/closing-issues-via-commit-messages/) if any.

Samples: (even more [samples](https://github.com/angular/angular/commits/master))

```
docs(changelog): update changelog to beta.5
fix(release): need to depend on latest rxjs and zone.js

The version in our package.json gets copied to the one we publish, and users need the latest of these.
```

### Revert

If the commit reverts a previous commit, it should begin with `revert: `, followed by the header of the reverted commit. In the body it should say: `This reverts commit <hash>.`, where the hash is the SHA of the commit being reverted.

### Type

Must be one of the following:

- **build**: Changes that affect the build system or external dependencies (example scopes: gulp, broccoli, npm)
- **ci**: Changes to our CI configuration files and scripts (example scopes: Circle, BrowserStack, SauceLabs)
- **docs**: Documentation only changes
- **feat**: A new feature
- **fix**: A bug fix
- **perf**: A code change that improves performance
- **refactor**: A code change that neither fixes a bug nor adds a feature
- **style**: Changes that do not affect the meaning of the code (white-space, formatting, missing semi-colons, etc)
- **test**: Adding missing tests or correcting existing tests

### Scope

The scope should be the name of the npm package affected (as perceived by the person reading the changelog generated from commit messages.

The following is the list of supported scopes:

- **animations**
- **common**
- **compiler**
- **compiler-cli**
- **core**
- **elements**
- **forms**
- **http**
- **language-service**
- **platform-browser**
- **platform-browser-dynamic**
- **platform-server**
- **platform-webworker**
- **platform-webworker-dynamic**
- **router**
- **service-worker**
- **upgrade**

There are currently a few exceptions to the "use package name" rule:

- **packaging**: used for changes that change the npm package layout in all of our packages, e.g. public path changes, package.json changes done to all packages, d.ts file/format changes, changes to bundles, etc.
- **changelog**: used for updating the release notes in CHANGELOG.md
- **docs-infra**: used for docs-app (angular.io) related changes within the /aio directory of the repo
- none/empty string: useful for `style`, `test` and `refactor` changes that are done across all packages (e.g. `style: add missing semicolons`) and for docs changes that are not related to a specific package (e.g. `docs: fix typo in tutorial`).

### Subject

The subject contains a succinct description of the change:

- use the imperative, present tense: "change" not "changed" nor "changes"
- don't capitalize the first letter
- no dot (.) at the end

### Body

Just as in the **subject**, use the imperative, present tense: "change" not "changed" nor "changes". The body should include the motivation for the change and contrast this with previous behavior.

### Footer

The footer should contain any information about **Breaking Changes** and is also the place to reference GitHub issues that this commit **Closes**.

**Breaking Changes** should start with the word `BREAKING CHANGE:` with a space or two newlines. The rest of the commit message is then used for this.

A detailed explanation can be found in this [document](https://docs.google.com/document/d/1QrDFcIiPjSLDn3EL15IJygNPiHORgU1_OOAqWjiDU5Y/edit#).

## Signing the CLA

Please sign our Contributor License Agreement (CLA) before sending pull requests. For any code changes to be accepted, the CLA must be signed. It's a quick process, we promise!

- For individuals we have a [simple click-through form](http://code.google.com/legal/individual-cla-v1.0.html).
- For corporations we'll need you to [print, sign and one of scan+email, fax or mail the form](http://code.google.com/legal/corporate-cla-v1.0.html).

------

If you have more than one Git identity, you must make sure that you sign the CLA using the primary email address associated with the ID that has been granted access to the Angular repository. Git identities can be associated with more than one email address, and only one is primary. Here are some links to help you sort out multiple Git identities and email addresses:

- <https://help.github.com/articles/setting-your-commit-email-address-in-git/>
- <https://stackoverflow.com/questions/37245303/what-does-usera-committed-with-userb-13-days-ago-on-github-mean>
- <https://help.github.com/articles/about-commit-email-addresses/>
- <https://help.github.com/articles/blocking-command-line-pushes-that-expose-your-personal-email-address/>

Note that if you have more than one Git identity, it is important to verify that you are logged in with the same ID with which you signed the CLA, before you commit changes. If not, your PR will fail the CLA check.