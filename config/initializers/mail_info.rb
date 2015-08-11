Rails.application.config.clone_instagram_mail = YAML.load_file('config/clone_instagram_mail.yml')[Rails.env]
