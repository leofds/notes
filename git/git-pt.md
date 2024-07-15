Este repositório contém uma lista de comandos Git úteis. Selecione o idioma: [English](https://github.com/leofds/notes/blob/master/git/git.md), [Portuguese](https://github.com/leofds/notes/blob/master/git/git-pt.md)

# Git

Lista de comandos Git

**Obter a versão instalada**

```
git --version
```

**Ajuda**

```
git help
git help <comando>
```

## Configuração

As configurações do GIT são armazenadas no arquivo **.gitconfig** localizado dentro do diretório do usuário do Sistema.

**Definir nome e e-mail do usuário**

```
git config --global user.name "Leonardo Fernandes"
git config --global user.email leonardo_.fernandes@hotmail.com
```

**Editor de texto Git**

```
git config --global core.editor "vi"
```

**Listar configurações**

```
git config --list
```

# Repositório Local

***staging area*** (Index) espaço temporário das mudanças que serão adicionadas.

**Criar repositório**

```
git init
```

**Status do repositório**

```
git status
```

**Adicionando arquivo à *staging area***

```
git add <nome_arquivo>                    
git add <nome_arquivo1> <nome_arquivo2>

git add .         # adiciona todos os arquivos
git add -u        # atualiza arquivos já adicionados
```

**Desfazendo a inclusão de um arquivo à *staging area***

```
git reset <nome_arquivo>
git reset         # todos os arquivos
```

## Commit

Salvar as alterações no repositório local

```
git commit -m “Primeiro commit”
```

### Squash

Juntar commits em um

```
git rebase -i HEAD~3        # 3 é o número dos últimos commits a juntar
                            # Após este comando o editor de texto abrirá, onde será listado os último commits que pretendemos juntar.
                            # É necessário mudar o comando "pick" que aparece antes de cada comando, para "squash", apenas
                            # nos commits que desejamos mudar.
                            # Após gravar este arquivo, um outro será aberto o a mensagem de texto desse commit
```

## reflog

```
git reflog
```

**Redefinir arquivos ao HEAD**

```
git reset --hard HEAD       # volta ao HEAD
git reset --hard HEAD^      # volta ao commit antes do HEAD
git reset --hard HEAD~1     # equivalente a "^"
git reset --hard HEAD~2     # volta dois commits antes do HEAD
```

**Desfazer último commit**

```
git reset HEAD~1           # Move para para trás no HEAD e no Index (Staging Area), Working Directory ainda contém as alterações
git reset -soft HEAD~1     # Move somente o ponteiro no repositorio (HEAD) para o commit anterior
git reset -hard HEAD~1     # Move para trás o HEAD, Index e Working Directory, porém o commit ainda existe no repositório, está salvo no reflog
```

**Mover o HEAD**

```
git reset HEAD@{1}
```

## Restaurar arquivo

Desfazendo alterações

```
git restore <nome_arquivo>
git restore .                # Todos os arquivos

git restore --staged <nome_arquivo>
git restore --staged .                # Todos os arquivos
```

## Reverter um commit

```
git revert <commit_hash>
```

Revertendo apenas um arquivo (2 formas)

```
git checkout <commit-hash> -- <file_name>
git restore -s <commit_hash> --  <file_name>
```

## Atualizando o último commit com as alterações correntes

```
git commit -a --amend --no-edit --date=now     # Atualizar com as alterações correntes
git commit --amend -m "<menssagem>"           # Atualizar a mensagem do último commit
```

## Ignorando arquivos com .gitignore

Arquivo com a configuração dos arquivos e diretórios que serão ignorados. O arquivo **.gitignore** deve estar na raiz do repositório.

Exemplo de arquivo **.gitignore**
```
# comentário
config.txt        # ignora o arquivo config.txt
build/            # ignora o diretório build
*.log             # ignora todos os arquivos com a extensão .log
!exemplo.log      # não ignora o arquivo exemplo.log
```

## Log

**Exibir histórico**

```
git log
git log -p -2                 # Diferença das duas últimas alterações
git log –stat                 # Resumo
git log --pretty=oneline      # Resumo em uma linha
git log --oneline --all
git log -- <nome_do_arquivo>  # Histórico de um arquivo
git log --author=leonardo     # Por author
git log --grep=<pattern>      # Mensagem de Log que corresponde ao padrão especificado
git log --diff-filter=M -- <nome_do_arquivo> # Histórico de modificação de um arquivo
                                             # (A) Adicionado, (C) Copiado, (D) Deletado, (M) Modificado, (R) Renomeado, ...
```

**Histórico com formatação**

```
git log --pretty=format:"%h, %an, %ar, %s"
```
+ **%h** Abreviação do hash
+ **%an** Nome do autor
+ **%ar** Data
+ **%s** Comentário

[Outras opções de formatação](http://git-scm.com/book/en/v2/Git-Basics-Viewing-the-Commit-History)

## Show

**Exibir as alterações de um commit**

```
git show <hash_do_commit>
git show <hash_do_commit>:<nome arquivo>
```

## Blame

**Mostrar qual revisão e autor modificou pela última vez cada linha de um arquivo**

```
git blame <nome_do_arquivo>
```

## Diff

**Visualizar diferencas entre versões do projeto**

Digite `q` para sair

```
git diff <hash_do_commit_1> <hash_do_commit_2>
git diff <hash_do_commit_1> <hash_do_commit_2> -- <nome_do_arquivo_1> <nome_do_arquivo_2>
git diff <branch1>..<branch2>
git diff --staged
```

## Tag

**Criar tag**

```
git tag <tagname>
```

**Criar tag anotada**

```
git tag -a <tagname> -m '<message>'
```

**Mostrar tags**

```
git tag
```

**Criar tag para um commit**

```
git tag <tag_name> <commit_sha>
```


## Voltar para um commit específico

**Cuidado!!!** O histórico será perdido.

```
git reset --hard <hash_do_commit/tag>
```

## Excluir arquivos não rastreados

```
git clean -n      # para ver um teste
git clean -f      # força a remoção dos arquivos não rastreados
git clean -f -d   # remove diretórios não rastreados
git clean -f -x   # remove arquivos .gitignore não rastreados também
git clean -fd
```

## Branches (ramos)

O branch principal é o **master**.

O HEAD é um ponteiro que indica qual é o branch atual.

O branch atual pode ser verificado pelo comando **git status**

**Listar os branches**

```
git branch
```

**Criar um novo branch**

```
git branch <nome_branch>
```

**Trocar para outro branch**

O HEAD vai apontar para o novo branch

```
git checkout <nome_branch>
```

**Criar um novo branch e mudar para ele**

```
git checkout -b <nome_branch>
```

**Voltar para o branch principal (master)**

```
git checkout master
```

**Integrar/Mesclar alterações de um branch com o master**

É preciso estar no branch principal (**master**).

```
git merge <branch_name>

git merge --abort                     // Aborta o merge se houver conflitos
git merge --continue                  // Continua o merge depois que os conflitos foram resolvidos. Provavelmente você precisará executar `git add .` primeiro.
```

Resolvendo conflitos automaticamente

```
git merge -X theirs <branch_name>    // A estratégia "theirs" resolve os conflitos favoritando as mudanças do branch <branch_name>.
git merge -X ours <branch_name>      // A estratégia "ours" resolve os conflitos favoritando as mudanças do branch atual.

**Rebase branch**

Sincroniza o branck atual com outro branck, movendo os commits para o ponto após o último commit do outro branch.

```
git checkout <nome_branch>
git rebase master
```

**Apagar branch**

```
git branch -d <nome_branch>
git branch -D <nome_branch>   # -D para branch que não houve merge
```

**Apagar todos os branches mantendo o master**

```
git branch | grep -v "master" | xargs git branch -D
```

Apagando branches como `master-prod` e `master-test`.

```
git branch | grep -v " master$" | xargs git branch -D
```

**Renomear branch**

```
git branch -m <old-branch> <new-branch>
```

## Arquivando alterações

```
git stash
git stash list
git stash pop
git stash clear
```

## Copiar um commit de uma branch para outra

```
git cherry-pick <hash_commit>
git cherry-pick -x <hash_commit>    # Adiciona uma mensagem "cherry picked from commit ..."
```

# Repositório Remoto

**Clonar um repositório remoto**

```
git clone <url_repositorio>
git clone <repository_url> -b <branch>
```

**Adicionar um repositório remoto**

```
git remote add origin <url_repositorio>
git remote add <branch_name> <url_repositorio>
```

**Remover um repositório remoto**

```
git remote remove <nemote_name>
```

**Exibir repositórios remoto**

```
git remote
git remote -v
git remote show origin
```

**Exibir URL do remoto**

```
git config --get remote.origin.url
```

**Alterar URL do remoto**

```
git remote set-url origin <git_repository_url>
```

**Enviar alterações para o repositório remoto**

```
git push -u origin master     # primeiro push deve conter o nome do repositório remoto e o branch
git push
git push origin --force       # força a sobreescria do remoto
git push origin HEAD
```

**Buscar as alterações do remoto**

```
git pull
git pull origin <branch_name>
git fetch             # Busca as alterações mas não aplica ao branch atual

# Atualizando o branch mantendo as alterações locais não comitadas (matém um hitórico linear)
git pull --all --rebase --autostash
```

**Criar tag no repositório remoto**

```
git push origin <nome_tag>
```

**Criando todas as tags no repositório remoto**

```
git push origin --tags
```


**Criando branch no remoto**

```
git push origin <nome_branch>
git push --set-upstream origin <nome_branch>

git push origin <nome_branch>:<novo_nome_branch>      # criando branch remoto com outro nome
```

**Criar um novo branch a partir de um branch remoto**

```
git checkout -b <nome_branch> origin/<nome_branch>
```

**Exibir os branches remotos**

```
git branch -r
```
