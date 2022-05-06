use anyhow::Result;
use clap::{Args, Subcommand};
use reqwest::blocking::Client;
use serde::Deserialize;
use serde_json::json;

#[derive(Deserialize, Debug)]
pub struct PasteResponse {
    pub content: String,
    pub id: String,
    pub is_url: bool,
}

#[derive(Debug, Args)]
#[clap(args_conflicts_with_subcommands = true)]
pub struct Paste {
    #[clap(subcommand)]
    pub command: Option<PasteCommands>,
}

#[derive(Debug, Subcommand)]
pub enum PasteCommands {
    Create(PasteCreate),
}

#[derive(Debug, Args)]
pub struct PasteCreate {
    pub body: String,
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
