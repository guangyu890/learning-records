# Git笔记

* 目标。熟悉使用git进行代码管理，同时使用git与github、gitee搭配使用，提升学习和开发效率。
* 重点。分支应用、git服务器搭建等。
* 参考。廖雪峰的官方网站、表严肃等。

***

## 一、Git的安装配置

* ubuntu系统下通过root帐户使用 apt install git即可。安装后可以使用git version查看当前版本。

* windows下通过官网下载安装。国内建议到腾讯软件中心下载安装（更新速度快）。

* 配置。安装完成后通分别通过以下命令进行配置。

  ```ssh
  git config --global user.name 'User Name'; //设置用户名
  git config --global user.email 'user's email';//设置用户邮箱
  git --list //进入当前仓库，查看当前配置。
  ```

## 二、版本库的管理

* 创建空仓库。在安装了git 软件的办公设备上选择一个适合的空目录（创建一个空文件夹），进入该目录。通过git init命令瞬间创建一个空仓库。

* 把文件添加到版本库。通过git add 'filename'命令把文件添加到暂存区，然后通过git commit -m 'commit message'命令把文件提交到版本库。

* 当版本库有变化时使用 git status命令随时撑握仓库当前的动态。

* 如果文件有修改我们用git diff '文件名'查看被修改的文件内容。确认修改内容后我们把所修改文件通过git add 命令提交到暂存区，然后使用git commit -m '提交信息' 提交到版本库。

  * 版本退回。使用git log查看提交命令。显示从最近到最远的提交日志。该命令可以使用 git log --pretty=oneline或者 git log --oneline。在Git中用HEAD表示当前版本，也就是最新的提交。上一个版本就是HEAD^，上上一个版本就是HEAD^^。需要退回到指定的版本可以使用git reset -- hard     ‘提交Id号’。
  * 使用git reset HEAD <FILE>可以把暂存区的修改撤销掉（unstage），重新放回工作区。
  * 使用git reflog查看命令历史，以便确定要回到未来的哪个版本。
  * 每次提交如果不用git add 到暂存区，那就不会加入到commit中。

* git checkout -- file 的使用。

  * 修改后还没有被放到暂存区，撤销修改就回到和版本库一模一样的状态。
  * 已经添加到暂存区后，又作了修改，现在，撤销修改就回到添加到暂存区后的状态。
  * 简而言之，就是让修改回到最近一次git commit或git add 时的状态。
  * 当改乱了工作区某文件的内容，想直接丢弃工作区的修改时，用命令git checkout --file。
  * 当不但改乱了工作区某个文件的内容，还添加到了暂存区时，想丢弃修改，分两步，第一用git reset HEAD <file>退回到了场景1,第二步按第1步走。
  * 已经提交了不适合的修改到版本库时，相要撤销本次提交，按版本退回，前提是没有推送到远程仓库。

* 文件删除。

  如果一个被修改提交的文件在工作区被删除了，使用git status查看仓库状态的时候Git提示说文件被删除了，如果确实要想删除该文件使用git rm <文件名>，然后git commit 就从版本库删除了该文件。

  如果是误删除文件且版本版还有，使用git checkout --<file name>可以恢复被删除的文件。也就是使用版本库里的版本替换工作区的版本，无论工作区是修改还是删除，都可以一键还原。

***

## 三、远程仓库

* 生态密钥。ssh-keygen -t ras -C '本人邮箱';
* 连接远程仓库。 git remote add origin ‘远程仓库地址’。
* git remote -v。查看远程仓库。
* git clone。通过该命令可以把远程仓库克隆到本地。
* git push -u origin master 。把本地分支推送到远程仓库分支上。 

## 四、分支操作

在Git操作中把每一次提交的时间节点串成一条时间线，这条时间线就是一个分支，即主分支。HEAD实际上不是指向提交而是指向分支。一开始的时候，master分支是一条线，Git用master指向最新的提交，再用HEAD指向master，就是确定当前主分支，以及当前分支的提交点。每次提交，master分支都会向前移动一步，这样，随着不断提交，master分支线会越来越长。

* 当我们在某个提交点创建新的分支时，Git创建了一个指针，指向master相同的提交，再把HEAD指向新建的分支上。
* 创建并切换分支。git checkout --b '分支名';
* 查看分支。git branch。*所在处就为当前分支。
* 合并删除分支。
  * 当在新的分支上完成工作时，可以使用git checkout master切换到主分支，再用git merge ‘新建分支名’把分支合并到主分支上，合并完成后使用git branch -d '分支'删除被合并的分支。

## 五、解决分支冲突

