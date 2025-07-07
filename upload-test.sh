#!/bin/bash

# Dropbox Access Token
ACCESS_TOKEN="sl.u.AF0XDn13n0jqDkQYWeVSKaERLTvq50xB5gyOnSRox8RWDjHTEd3gg03k4U1mbB6SSjkWisHef8_VSkBl-LAee34wkPKjtKHoZcPdZhhf9gDmOHY2--xBd5Tjt4zWJCzJYTO-AQ0D5NmCKCnZo2d4TLpca6cC4UMBIj6hC2gWYrvqt9OZqVN_ARw3lQb6nnETnSdhj7nZh6WEWIJNolxyT2L5ToUkCM2B_6KGkqU63h4mOfb0_qe79Ttixiq-lSBdefkX9BrdzJUpLDYvhqiaXNPAp_K0EeoE1Ir43DYAdM63Iycw1sO2tT0FrXR0QoT09kcOj8bKBCPx0Z9n-HoNF22_Yw8zqApF0MWYEpTVlwCge0i5fKBdwpQy-wu8U4eIpApL3uXZv9ElezM4ILbSO0ropVyQMJ7mQPNFehtWvvlQMmSi2_hN1dURvKpCE8j2tUkQM_muMYZvSETRjseq0CoiSV2tfF-l0KFRrneaaN3LYSlN05ksCaq3iwDn9aRAHlfZM4oOxLkLuXwH0KpzJ7s0wbnZUusKkFlsoxE90AJJhYOLplgJblnuQa6t-5i1vHeFlbBgdtkK2HdODkvRpOPyPYxyTPKux8w6pmhh4Scpel1VN7Jdp60nlasJp8mBzqkkxmYm_3Euxq_bV7T5qAy7fLeX1eNt5qaZGnxG9DuTFOxPj-1SktJmnDml-YPS01Wy_wJrCWf1nBxeWukWdZ9UuTscC4uaDC4z-5H0FJTBKthX8Jc6_yW9_fjlbwaGGNiGgCECZzfsNJbCnra5g2CTXFVV5grsUBrwBM1xxZwVzrgbrPrdBaGlcyJjsSREbDaFfymRqWSCqgaUXBWvC1CaFohoiUpzVk4OFP0cZN-7in-dfNxOznFZ2zHNcMiq8TUAj8rnVlxDYQweAtfHCE-WmwMOS0Lp6CAypAO5lxjh3rFpkJ4OY6r4f8afcx39n4Qjx1s6f8F8OD3Ar3qNa0kf_kpakVg91kiHpiUA1MZ_zdfB9fvzzdQCVL-ja-dJXCO7bZheCZLH6mdUnm5ZlAeP08kzgKaIRjqYVoeXToRO5gw1GAIuC0-DyAUm_DUv2G_UZGqQjeGE2J9scMXoHs2mz82yScCtrM_MhYqz7YLYi3ubwjOHmbyAnXf9DyR97IprVOudAwYuxpKB5M-Jr4HG27_Gv0tNnX4uOIwN2xIRh6_HKUTkGAiyp1nFn2IFmaw5uo1jC0du-aNj9R1QJ449rh9fsp4FCosjX1zMZ3LMzTAC1uJz0kcK0-JhZjP31QPI-07whzAGLd3Gs3ugYo4w"

# Files to upload
FILES=("dalle_image_1.png" "dalle_image_2.png" "background_audio.mp3")

echo "🟡 Starting upload process..."

# Loop through and upload each file
for FILE in "${FILES[@]}"; do
    if [[ -f "$FILE" ]]; then
        echo "🟢 Uploading $FILE to Dropbox..."
        curl -X POST https://content.dropboxapi.com/2/files/upload \
            --header "Authorization: Bearer $ACCESS_TOKEN" \
            --header "Dropbox-API-Arg: {\"path\": \"/FFmpegUploader/$FILE\", \"mode\": \"overwrite\"}" \
            --header "Content-Type: application/octet-stream" \
            --data-binary @"$FILE"
        echo "✅ $FILE uploaded."
    else
        echo "❌ File not found: $FILE"
    fi
done

echo "🎉 All done."
