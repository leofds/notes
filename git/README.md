This repository contains a list of useful Git commands. Select the language: [English](https://github.com/leofds/notes/blob/master/git/README.md), [Portuguese](https://github.com/leofds/notes/blob/master/git/README-pt.md)

# Git

Git command list

**Get installed version**

```
git --version
```

**Help**

```
git help
git help <command>
```

## Configurations

The Git configurations are stored in **.gitconfig** file, in the user's home directory.

**Setting username and email**

```
git config --global user.name "Leonardo Fernandes"
git config --global user.email leonardo_.fernandes@hotmail.com
```

**Git text editor**

```
git config --global core.editor "vi"
```

**List settings**

```
git config --list
```

# Local repository

***staging area*** (Index) temporary area of the changes that will be added to the repository.

**Create repository**

```
git init
```

**Repository status**

```
git status
```

**Adding file to *staging area***

```
git add <file_name>                    
git add <file_name1> <file_name2>

git add .         # add all modified files
git add -u        # update files already added
```

**Undoing the inclusion of a file in the *staging area***

```
git reset <file_name>
git reset         # all files
```

## Commit

Save changes to a local repository

```
git commit -m “First commit”
```

### Squash

**Join some commits into one**

```
git rebase -i HEAD~3        # 3 is the number of the last commits to join
```

## reflog

```
git reflog
```

**Redefine files to HEAD**

```
git reset --hard HEAD       # back to HEAD
git reset --hard HEAD^      # back to commit before HEAD
git reset --hard HEAD~1     # equals to "^"
git reset --hard HEAD~2     # back two coomits before HEAD
```

**Undo last commit**

```
git reset HEAD~1           # Move the HEAD and Index (Staging Area) to the back, Working Directory still has the changes
git reset -soft HEAD~1     # Move only the HEAD to the previous commit
git reset -hard HEAD~1     # Move the HEAD, Index, and Working Directory to the back, although the commit still exists in repository, it is saved in the reflog
```

**Move the HEAD**

```
git reset HEAD@{1}
```

## Restore the file

Undoing changes

```
git restore <file_name>
git restore .                # All files

git restore --staged <file_name>
git restore --staged .                # All files
```

## Revert a commit

```
git revert <commit_hash>
```

Reverting just one file (2 ways)

```
git checkout <commit-hash> -- <file_name>
git restore -s <commit_hash> --  <file_name>
```

## Update the last commit with current changes

```
git commit -a --amend --no-edit --date=now
git commit --amend -m "<message>"           # Update the last commit message
```

## Ignoring files with .gitignore

File with the files and directory that will be ignored. The file **.gitignore** must be in the root directory of the repository.

**.gitignore** example file
```
# comment
config.txt        # ignores the file config.txt
build/            # ignores the directory build
*.log             # ignores all files ending with .log
!exemplo.log      # doesn't ignore the file exemplo.log
```

## Log

**Show history**

```
git log
git log -p -2                 # Difference netween the last two changes
git log –stat                 # Summary
git log --pretty=oneline      # One line summary
git log --oneline --all
git log -- <file_name>        # File history
git log --author=leonardo     # By author
git log --grep=<pattern>      # Log messsage that matches the specified pattern
git log --diff-filter=M -- <file_name>    # File modification history
                                             # (A) Added, (C) Copied, (D) Deleted, (M) Modified, (R) Renamed, ...
```

**Historic with formatting**

```
git log --pretty=format:"%h, %an, %ar, %s"
```
+ **%h** Hash summary
+ **%an** Author name
+ **%ar** Date
+ **%s** Comment

[Other formatting options](http://git-scm.com/book/en/v2/Git-Basics-Viewing-the-Commit-History)

## Show

**Show commit changes**

```
git show <commit_hash>
git show <commit_hash>:<file_name>
```

## Blame

**Show which revision and author last modified each line of a file**

```
git blame <file_name>
```

## Diff

**See differences between project versions**

Type `q` to exit

```
git diff <commit_hash1> <commit_hash2>
git diff <commit_hash2> <commit_hash2> -- <file_name1> <file_name2>
git diff <branch1>..<branch2>
git diff --staged
```

## Tag

**Create tag**

```
git tag <tagname>
```

**Create annotated tag**

```
git tag -a <tagname> -m '<message>'
```

**Show tags**

```
git tag
```

**Create tag for a commit**

```
git tag <tag_name> <commit_hash>
```


## Go back to a specific commit

**Watch out!!!** The history will be lost

```
git reset --hard <commit_hash/tag>
```

## Clean untracked files

```
git clean -n      # to see a dry run
git clean -f      # force untracked file deletion
git clean -f -d   # remove untracked directories
git clean -f -x   # to remove untracked .gitignore files too
git clean -fd
```

## Branches

The main branch is the **master**.

The HEAD is a pointer that indicates which is the current branch.

The current branch can be verified by the command **git status**

**List branches**

```
git branch
```

**Create new branch**

```
git branch <branch_name>
```

**Switch to another branch**

The HEAD will point to the new branch

```
git checkout <branch_name>
```

**Create a new branch and switch to it**

```
git checkout -b <branch_name>
```

**Go back to the main branch (master)**

```
git checkout master
```

**Merge changes from a branch to master**

It's necessary to be on the main branch (**master**).

```
git merge <branch_name>

git merge --abort                     // Aborts the merge if there are conflicts.
git merge --continue                  // Continue the merge after the conflicts are solved. Probably you will need to run `git add .` first.
```

Automatically resolving conflicts

```
git merge -X theirs <branch_name>    // The strategy "theirs" conflicts by favoring the changes from the <branch_name> branch.
git merge -X ours <branch_name>      // The strategy "ours" resolves conflicts by favoring the changes from the current branch.
```

**Rebase branch**

Sync the current branch with the other branch, moving commits to the point after the last commit of the other branch.

```
git checkout <branch_name>
git rebase master
```

**Delete branch**

```
git branch -d <nome_branch>
git branch -D <nome_branch>   # -D for non merged branch
```

**Delete all branches keeping master**

```
git branch | grep -v "master" | xargs git branch -D
```

Deleting branches such as `master-prod` or `master-test`.

```
git branch | grep -v " master$" | xargs git branch -D
```

**Rename branch**

```
git branch -m <old-branch> <new-branch>
```

## Archiving the changes

```
git stash
git stash list
git stash pop
git stash clear
```

## Copy a commit from one branch to another one

```
git cherry-pick <commit_hash>
git cherry-pick -x <commit_hash>    # Add a message "cherry picked from commit ..."
```

# Remote repository

**Clone a remote repository**

```
git clone <repository_url>
git clone <repository_url> -b <branch>
```

**Add a  remote repository**

```
git remote add origin <repository_url>
git remote add <branch_name> <repository_url>
```

**Delete a remote repository**

```
git remote remove <nemote_name>
```

**Show remote repositories**

```
git remote
git remote -v
git remote show origin
```

**Show remote URL**

```
git config --get remote.origin.url
```

**Change remote URL**

```
git remote set-url origin <git_repository_url>
```

**Send changes to the remote repository**

```
git push -u origin master     # The first push must have the remote repository name and the branch name
git push
git push origin --force       # Forces the overwrite on the remote
git push origin HEAD
```

**Pull changes from the remote**

```
git pull
git pull origin <branch_name>
git fetch             # Fetch changes but does not apply to the current branch

# Updating the branch keeping the uncommitted local changes (keeps a linear history)
git pull --all --rebase --autostash
```

**Create a tag in the remote**

```
git push origin <tag_name>
```

**Creating all the tags in the remote**

```
git push origin --tags
```


**Create a branch in the remote**

```
git push origin <branch_name>
git push --set-upstream origin <branch_name>

git push origin <branch_name>:<new_branch_name>      # creating with other name
```

**Create a new branch from a remote branch**

```
git checkout -b <branch_name> origin/<branch_name>
```

**Show the remote branches**

```
git branch -r
```
