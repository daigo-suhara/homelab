## 概要

自宅サーバのOSインストールからKubernetesクラスタの構築・運用，アプリケーションのデプロイまでをGitOpsで自動化するためのリポジトリです．

## 手順

1. このリポジトリをクローンします
```bash
git clone https://github.com/daigo-suhara/homelab.git
cd homelab
```

2. `ansible/inventory.ini`に，ClusterAPI管理用サーバーのIPアドレスとSSHユーザーを設定し、Playbookを実行します

```bash
cd ansible
ansible-playbook bootstrap.yaml
```

3. Argo CDにMetal3関連リソースのデプロイが登録されます．

Argo CDによる同期が進むと，Metal3が対象の物理サーバを検知し，電源の起動，OSのインストール，Kubernetesクラスタの構築が始まります．
