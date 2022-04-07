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

**Definir nome do usuário**

```
git config --global user.name "Leonardo Fernandes"
```

**Definir e-mail do usuário**

```
git config --global user.email leonardo_.fernandes@hotmail.com
```

**Listar configurações**

```
git config --list
```

## Repositório Local

***staging area*** espaço temporário das mudanças que serão adicionadas.

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
```

**Adicionando todos os arquivo à *staging area***

```
git add .
```

**Desfazendo a inclusão de um arquivo à *staging area***

```
git reset <nome_arquivo>
```

**Desfazendo a inclusão de todos os arquivos à *staging area***

```
git reset
```

## Commit

Salvar as alterações no repositório local

```
git commit -m “Primeiro commit”
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
```

**Exibir histórico com a diferença das duas últimas alterações**

```
git log -p -2
```


**Exibir resumo do histórico**

```
git log –stat
```

**Exibir histórico resumido em uma linha**

```
git log --pretty=oneline
```

**Exibir histórico com formatação**

```
git log --pretty=format:"%h, %an, %ar, %s"
```
+ **%h** Abreviação do hash
+ **%an** Nome do autor
+ **%ar** Data
+ **%s** Comentário

[Outras opções de formatação](http://git-scm.com/book/en/v2/Git-Basics-Viewing-the-Commit-History)

**Histórico de um arquivo**

```
git log -- <nome_do_arquivo>
```

**Histórico de modificação de um arquivo**

```
git log --diff-filter=M -- <nome_do_arquivo>
```
(A) Adicionado, (C) Copiado, (D) Deletado, (M) Modificado, (R) Renomeado, ...

**Histórico por autor**

```
git log --author=leonardo
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

## Voltar para um commit específico

**Cuidado!!!** O histórico será perdido.

```
git reset --hard <hash_do_commit/tag>
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
git branch -b <nome_branch>
```

**Voltar para o branch principal (master)**

```
git checkout master
```

**Juntar um branch com o master**

É preciso estar no branch principal (**master**).

```
git merge <nome_branch>
```

**Apagar branch**

```
git branch -d <nome_branch>
```

**Apagar branch que não houve merge**

```
git branch -D <nome_branch>
```
