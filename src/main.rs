use std::{
    env,
    ffi::OsString,
    io::{self, Read},
};

use clap::Parser;

use colored::*;

mod paste;

#[derive(Debug, Parser)]
#[clap(name = "katbin")]
#[clap(author, version, about = "a command line interface for katb.in", long_about = None)]
struct Cli {
    body: String,
}

fn stdin_to_args() -> Vec<OsString> {
    let mut args: Vec<OsString> = env::args_os().collect();

    let mut body = String::from("");
    io::stdin().read_to_string(&mut body).unwrap();
    args.push(body.into());

    args
}

fn main() {
    // parse CLI arguments
    let args: Cli;

    // no input from stdin
    if atty::is(atty::Stream::Stdin) {
        args = Cli::parse();
    } else {
        // parse input from stdin
        args = Cli::parse_from(stdin_to_args().iter());
    }

    // match commands
    match paste::create_paste(args.body) {
        Ok(paste) => {
            let url = format!("https://katb.in/{}", paste.id.blue());
            if paste.is_url {
                let view_url = format!("https://katb.in/v/{}", paste.id);
                println!(
                    "Short URL created successfully. Access it at {}, and view it at {}.",
                    url.bright_blue(),
                    view_url.bright_blue()
                );
            } else {
                println!(
                    "Paste created successfully. Access it at {}.",
                    url.bright_blue()
                );
            }
        }
        Err(err) => {
            println!("error: {}", err)
        }
    }
}
