Задача №11: Terraform

Поднять в AWS с помощью Terraform или OpenTofu (по желанию) следующее:

    Весь VPC (public и private subnet)
    2 сервера:
        Bastion host (публичный)
        Private server (приватный)
    Security Groups (SG)
    Postgres DB

Требования

    Использовать модули.
    Разобраться, как взаимодействуют между собой variables.tf и output.tf в модулях.
    Настроить Security Group для доступа на 22 порт только со своего IP.
    Использовать переменную типа object для передачи необходимых IP для подключения на порт 22 (передать IP + имя правила).

Примечания

    Версия OpenTofu: v1.8.1