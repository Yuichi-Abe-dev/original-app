# Readme

## users テーブル

| Column     | Type   | Options     |
| --------   | ------ | ----------- |
| email      | string | null: false |
| password   | string | null: false |
| name       | string | null: false |
| profile    | text   | null: false |
| occupation | text   | null: false |
| position   | text   | null: false |

### Association

- has_many :prototypes
- has_many :comments

## tweets テーブル

| Column   | Type   | Options     |
| -------- | ------ | ----------- |
| text     | string | null: false |
| image    | string | null: false |
| user_id  | string | null: false |

### Association
- belongs_to :user
- has_many :comments
