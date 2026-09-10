## 概要

IPMIを搭載した物理サーバへのOSインストールからKubernetesクラスタの構築，アプリケーションのデプロイまでを自動化するためのシステムです

## 使用OSS

- metal3
- OpenStack Ironic
- Cluster API
- Argo CD
- Kubernetes

## 手順

ここからの作業は，管理用サーバ（Ubuntu）上で行います

1. まずこのリポジトリをクローンします
```bash
git clone https://github.com/daigo-suhara/gitops-metal3.git
```

2. 以下のコマンドを実行します

```bash
./scripts/bootstrap.sh
```

3. MicroK8sとArgo CDがインストールされ，Argo CDにMetal3関連リソースのデプロイが登録されます．

その後，Argo CDによる同期が進むと，Metal3が3台の物理サーバを検知し，電源の起動，OSのインストール，Kubernetesクラスタ（3台のコントロールプレーン）の構築を行います．

ワーカーノードは現在の設定では0台です。必要に応じて`cluster/workers.yaml`の`MachineDeployment.spec.replicas`を変更してください。

## ディレクトリ構成

- `argocd/management/applications/`: Argo CD Application 定義
- `argocd/management/manifests/`: CAPI、Metal3、IrSO の実体マニフェスト
- `argocd/workloads/applications/`: ワークロード用 Argo CD Application 定義
- `argocd/workloads/manifests/`: ワークロードの実体マニフェスト

既存の環境をこの構成へ移行する場合は、一度だけ次を実行して App-of-Apps の同期先を更新してください。

```bash
kubectl apply -f argocd/management/applications/app-of-apps.yaml
```
