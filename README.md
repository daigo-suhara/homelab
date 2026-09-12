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

## 外部 DNS での公開

`daigo-suhara.com` の A レコードを自宅のグローバル IP に向けたうえで、ルーターで TCP `80` と `443` を `172.16.100.110`（`ingress-nginx-controller` の Cilium L2 LoadBalancer IP）へ転送します。Argo CD の同期後、`https://daigo-suhara.com` は `mysite` に到達し、cert-manager が Let's Encrypt の証明書を HTTP-01 で取得・更新します。

サブドメインを公開する際は、DNS にその名前の A レコード（または `*.daigo-suhara.com` のワイルドカード A レコード）を同じグローバル IP へ追加し、対象サービスの `Ingress` に対応する `host` と TLS 設定を追加します。
