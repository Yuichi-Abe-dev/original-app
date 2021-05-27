# Readme
## アプリケーション概要	
CADに関するツールや3Dモデルを投稿・共有することが可能です。Dynamo・Grasshopperなど作成できるビジュアルプログラムを売買・共有・受発注するwebサイトがなく、SNSの有志同士のコミュニティなどをきっかけに、取引・契約が行われることがあります。そこで、このアプリケーションを介して情報共有などを行えるようにしたいと考えました。

## users テーブル

| Column     | Type   | Options     |
| ---------- | ------ | ----------- |
| email      | string | null: false |
| password   | string | null: false |
| name       | string | null: false |
| profile    | text   | null: false |
| occupation | text   | null: false |
| position   | text   | null: false |

### Association

- has_many :prototypes
- has_many :comments

## prototypes テーブル

| Column        | Type            | Options     |
| ------------- | --------------- | ----------- |
| title         | string          | null: false |
| catch_copy    | text            | null: false |
| concept       | text            | null: false |
| image         | ActiveStorage   | null: false |
| user          | references      | null: false |


### Association
- belongs_to :user
- has_many :comments

## comments テーブル

| Column        | Type       | Options     |
| ------------- | ---------- | ----------- |
| text          | text       | null: false |
| user          | references | null: false |
| prototype     | references | null: false |

### Association
- belongs_to :user
- belongs_to :prototype
