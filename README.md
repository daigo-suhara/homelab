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
git clone https://github.com/daigo-suhara/homelab.git
cd homelab
```

2. 以下のコマンドを実行します

```bash
./scripts/bootstrap.sh
```

3. MicroK8sとArgo CDがインストールされ，Argo CDにMetal3関連リソースのデプロイが登録されます．

bootstrap は `sudo microk8s kubectl` を使って管理クラスタを操作します。
既存の kubeconfig は変更しません。実行ディレクトリに依存せず動作します。

その後，Argo CDによる同期が進むと，Metal3が3台の物理サーバを検知し，電源の起動，OSのインストール，Kubernetesクラスタ（3台のコントロールプレーン）の構築を行います．

ワーカーノードは現在の設定では0台です。必要に応じて`cluster/workers/machine-deployment.yaml`の`MachineDeployment.spec.replicas`を変更してください。

## ディレクトリ構成

- `argocd/bootstrap/`: 管理クラスタ用 App-of-Apps の初期登録
- `argocd/management/`: 管理クラスタ用 Argo CD Application 定義
- `argocd/management/ironic/`: Ironic Application と環境固有マニフェスト
- `argocd/workloads/`: ワークロード用 Argo CD Application 定義
- `argocd/workloads/cilium/`: Cilium の LoadBalancer IP Pool と L2 Policy
- `argocd/workloads/mysite/`: mysite Application と実体マニフェスト
- `hardware/`: BareMetalHost と BMC 認証 Secret
- `cluster/`: Cluster API によるワークロードクラスタの定義
- `cluster/addons/`: ワークロードクラスタへ配布する HelmChartProxy と ClusterResourceSet

管理クラスタ用 App-of-Apps は `management/` を同期します。
ローカル設定を持つ Application だけをディレクトリにまとめています。
各 Application が `hardware/`、`cluster/` などを個別に同期します。
ワークロード用 App-of-Apps は `cluster/addons/argocd.yaml` の
Argo CD Helm release が登録し、`workloads/` を同期します。
`argocd/` 全体を再帰的に同期しないでください。管理用とワークロード用は別クラスタ向けです。

既存の環境をこの構成へ移行する場合は、変更を Git に push してから、
管理クラスタのコンテキストで一度だけ次を実行してください。

```bash
kubectl apply -f argocd/bootstrap/app-of-apps.yaml
```

ワークロード用 App-of-Apps の同期先は ClusterResourceSet が更新します。

## 検証

```bash
bash scripts/validate.sh
git diff --check
```

`kubectl` とネットワーク接続が必要です。すべての Kustomization をレンダリングし、
シェルスクリプトの構文も確認します。クラスタへの適用、Helm Application 内の
チャート展開、CRD スキーマ検証、実機動作確認は含みません。

削除済みの metrics-server、sealed-secrets、ワークロード用 cert-manager、
cloudflared、jupyterhub、hermes は Application / add-on 一覧からも除外しています。
再導入時はマニフェストと Kustomization の参照を一緒に追加してください。
既存クラスタでは、同期前にこれらの削除に伴う prune 差分を確認してください。
