import requests

ACCESS_TOKEN = "sl.u.AF2BsbBp3b-HT7gkYf0BtK8WAyqrYsTr3nLBclsEyupuVCTR6OM3Tx0G7StAVjLWcgPluYTXZX3zFqrfOmGFC7bCpW_T3HL-8kVXuWod8lXytrS5JAcGZ_I3XP5XL1TX7nXbQ8KYowHUSrbSWtDILJEo2C2_7cXlezlUN8FuXiTYK8ZrC6YMeBN0Z3MyNlHDlKjwrEh46vPvWsBgDkoQzublmdTQs0Mf8mOrofq1FAnioU2wlY0R5WD0o5IVOQsDee8lkhsXQhsdLgfY7cXjHupanH5MpTf4b7E3itSDICmq9RRYDlfzcbmI0fmRvX9ow_rzQm5D_zt_XPWDx9dAeDtWUiisxPuSJaQA5GzkVFPfp8a2Sd7aPRapkIMQbwGkC1YfzFHeUf2ZYkDhMqVeumoUoC3_CsN4RDH3d8_QhKWmPzJ9Nks10_FgkQnYBv52OiCqr6COmdrsFfIWcN1WXT3zkDxzRk4FjWEBfo1nT1-mEXguTeHtXbjlikvy00pkTOLDCdFb02-vhSY3Znu6JzlXUH2hIEzwj_CX2FMD5pAqr2DVoy5cZQp5aghwwQ_tel4-557yRe75RN0zhFLO9roXvDvcOogV5dJfjjlaWYgAsDXJG0G43LqSwiE6yE5xpBokQdW1BdIyIfpxBSEoWfq0V3OJisvjVgwp2wcMrj0GAxK9v0kWaorglhhz-ZHUVxGn8G-zt3iZvbij3m1_X5Kevrqbgb1lb4toVO0jVQ-50g2bLSc3BNg2Q6DxawovwMNjTgKtl6qO3j2gxVhh9s3bNsPs2V6K4gtGny6ctrRd6qVRUvGwTa44ghmJV8Biv2xlD3ZETEDKboH2oasZwYTmSqNmhEguqoGPvq1yyY-MEgGjD_bnKCXjvxaAkrtLet1VGSi5oqbBupK7YueGQWHCjpwaWA1Y2mM87E65IsLE2p3DFt1oJMPRaa0KIaZJQrtwLG_TyUWtqiXdNLK8aRPeHzU2sFDZqz5J178h41QIM8b-xorCF7I1whBrddQ2qzhgRyd7slFXAlsckaAnEcclwEKB8m0M8pwAQLuOunWxnHvQ1UbSaqwKD9LHew8eJAeWICJT3VOxCtbNNhONp8jzSVB-tlA8jFlun1gQG7K5VNmcwIh6x_ZK5KcOz-DaPnByprOpg0kbn7M2lrYOGJUbeHh6Zh4_5ixp1thFK0MlY2-QxBwAGOSylUpcItdiDKwJLmokLngEaDgMV_Dha43wlDTdUxkW9pH_P0vecu9wGOD8HJMb1REqb1FwVlGSSLQ"

files = ["dalle_image_1.png", "dalle_image_2.png", "background_audio.mp3"]
dropbox_folder = "/FFmpegUploader"

for file_name in files:
    with open(file_name, "rb") as f:
        data = f.read()
    print(f"Uploading {file_name} to Dropbox...")
    response = requests.post(
        "https://content.dropboxapi.com/2/files/upload",
        headers={
            "Authorization": f"Bearer {ACCESS_TOKEN}",
            "Dropbox-API-Arg": str({
                "path": f"{dropbox_folder}/{file_name}",
                "mode": "overwrite",
                "autorename": False,
                "mute": False
            }).replace("'", '"'),
            "Content-Type": "application/octet-stream"
        },
        data=data
    )
    print(f"{file_name}: {response.status_code}, {response.text}")
