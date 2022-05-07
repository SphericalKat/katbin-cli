use anyhow::Result;
use reqwest::blocking::Client;
use serde::Deserialize;
use serde_json::json;

#[derive(Deserialize, Debug)]
pub struct PasteResponse {
    pub content: String,
    pub id: String,
    pub is_url: bool,
}

pub fn create_paste(body: String) -> Result<PasteResponse> {
    let paste = json!({
        "paste": {
            "content": body
        }
    });

    let response = Client::new()
        .post("https://katb.in/api/paste")
        .json(&paste)
        .send()?;

    let created_paste: PasteResponse = response.json()?;
    Ok(created_paste)
}
