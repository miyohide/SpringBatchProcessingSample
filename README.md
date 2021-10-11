# これは何か

Spring Batchで作った簡単なバッチ処理のサンプル＋Azure Container Instance上で動かすための各種デプロイ情報をTerraformで書いたサンプルプロジェクトです。

# Terraform

`deploy`ディレクトリ以下にサンプルを書いています。

以下のコマンドで、Azure Container Registry、Azure Database for PostgreSQL、Azure Storage Accountを作成します。

```shell
$ cd aci_with_acr/01_prepare
$ terraform init
$ terraform apply
```

Azure Database for PostgreSQLのユーザ名やパスワードはAzure KeyVaultにあらかじめ設定しておく必要があります。ユーザ名のキーは`db_user_key`、パスワードのキーは`db_password_key`です。
`terraform apply`を実行したときにAzure KeyVaultの名前とリソースグループが聞かれるので入力します。

その後、以下のコマンドを使ってAzure Container Instanceを作成します。

```shell
$ cd ../02_aci
$ terraform init
$ terraform apply -var-file ../01_prepare/terraform.tfvars
```
