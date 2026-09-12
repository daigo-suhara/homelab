## 概要

IPMIを搭載した物理サーバへのOSインストールからKubernetesクラスタの構築，アプリケーションのデプロイまでをGitOpsで自動化するためのシステムです

## 手順

1. このリポジトリをクローンします
```bash
git clone https://github.com/daigo-suhara/homelab.git
cd homelab
```

2. `ansible/inventory.ini`に管理サーバーのIPアドレスとSSHユーザーを設定し、Playbookを実行します

```bash
cd ansible
ansible-playbook bootstrap.yaml
```

3. Argo CDにMetal3関連リソースのデプロイが登録されます．

Argo CDによる同期が進むと，Metal3が3台の物理サーバを検知し，電源の起動，OSのインストール，Kubernetesクラスタ（3台のコントロールプレーン）の構築を行います．

4. 構築後、ワークロードクラスタのkubeconfigを手元へ保存します

```bash
make kubeconfig
export KUBECONFIG="$HOME/.kube/homelab"
kubectl get nodes
```
