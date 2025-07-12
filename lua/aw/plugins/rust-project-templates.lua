-- =============================================================================
-- Rust Project Templates and Workflow Automation
-- =============================================================================
-- Automated project setup, templates, and workflow management for Rust
-- Features: Project templates, CI/CD setup, dependency management

local M = {}

-- =============================================================================
-- PROJECT TEMPLATES
-- =============================================================================

local templates = {
  binary = {
    name = "Binary Application",
    description = "Standard Rust binary project with logging and CLI",
    dependencies = {
      "clap = { version = \"4.0\", features = [\"derive\"] }",
      "env_logger = \"0.10\"",
      "log = \"0.4\"",
      "anyhow = \"1.0\"",
      "tokio = { version = \"1.0\", features = [\"full\"] }",
    },
    dev_dependencies = {
      "assert_cmd = \"2.0\"",
      "predicates = \"3.0\"",
      "tempfile = \"3.0\"",
    },
    files = {
      ["src/main.rs"] = [[
use anyhow::Result;
use clap::Parser;
use env_logger::Env;
use log::{debug, info};

#[derive(Parser)]
#[command(name = "{{PROJECT_NAME}}")]
#[command(about = "A Rust CLI application")]
struct Cli {
    #[arg(short, long)]
    verbose: bool,
    
    #[arg(short, long, default_value = "info")]
    log_level: String,
}

#[tokio::main]
async fn main() -> Result<()> {
    let cli = Cli::parse();
    
    // Initialize logger
    let env = Env::default().default_filter_or(&cli.log_level);
    env_logger::init_from_env(env);
    
    info!("Starting {{PROJECT_NAME}}");
    debug!("Verbose mode: {}", cli.verbose);
    
    // Your application logic here
    
    Ok(())
}
]],
      ["tests/integration_test.rs"] = [[
use assert_cmd::Command;
use predicates::prelude::*;

#[test]
fn test_help() {
    let mut cmd = Command::cargo_bin("{{PROJECT_NAME}}").unwrap();
    cmd.arg("--help");
    cmd.assert()
        .success()
        .stdout(predicate::str::contains("{{PROJECT_NAME}}"));
}

#[test]
fn test_version() {
    let mut cmd = Command::cargo_bin("{{PROJECT_NAME}}").unwrap();
    cmd.arg("--version");
    cmd.assert()
        .success()
        .stdout(predicate::str::contains(env!("CARGO_PKG_VERSION")));
}
]],
    },
  },
  
  library = {
    name = "Library Crate",
    description = "Rust library with comprehensive testing and documentation",
    dependencies = {
      "thiserror = \"1.0\"",
      "serde = { version = \"1.0\", features = [\"derive\"] }",
    },
    dev_dependencies = {
      "criterion = \"0.5\"",
      "proptest = \"1.0\"",
      "tokio-test = \"0.4\"",
    },
    files = {
      ["src/lib.rs"] = [[
//! # {{PROJECT_NAME}}
//! 
//! A Rust library crate.
//! 
//! ## Usage
//! 
//! ```rust
//! use {{PROJECT_NAME}}::*;
//! 
//! // Example usage
//! ```

use thiserror::Error;

#[derive(Error, Debug)]
pub enum {{PROJECT_NAME_PASCAL}}Error {
    #[error("Invalid input: {0}")]
    InvalidInput(String),
    #[error("IO error: {0}")]
    Io(#[from] std::io::Error),
}

pub type Result<T> = std::result::Result<T, {{PROJECT_NAME_PASCAL}}Error>;

/// Main library functionality
pub fn hello() -> &'static str {
    "Hello, world!"
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_hello() {
        assert_eq!(hello(), "Hello, world!");
    }
}
]],
      ["benches/benchmark.rs"] = [[
use criterion::{black_box, criterion_group, criterion_main, Criterion};
use {{PROJECT_NAME}}::*;

fn bench_hello(c: &mut Criterion) {
    c.bench_function("hello", |b| b.iter(|| hello()));
}

criterion_group!(benches, bench_hello);
criterion_main!(benches);
]],
    },
  },
  
  web_service = {
    name = "Web Service",
    description = "Async web service with Axum and database",
    dependencies = {
      "axum = \"0.7\"",
      "tokio = { version = \"1.0\", features = [\"full\"] }",
      "tower = \"0.4\"",
      "serde = { version = \"1.0\", features = [\"derive\"] }",
      "serde_json = \"1.0\"",
      "sqlx = { version = \"0.7\", features = [\"runtime-tokio-rustls\", \"postgres\"] }",
      "anyhow = \"1.0\"",
      "env_logger = \"0.10\"",
      "log = \"0.4\"",
    },
    dev_dependencies = {
      "axum-test = \"14.0\"",
      "tower-test = \"0.4\"",
    },
    files = {
      ["src/main.rs"] = [[
use axum::{
    extract::State,
    http::StatusCode,
    response::Json,
    routing::{get, post},
    Router,
};
use serde::{Deserialize, Serialize};
use std::sync::Arc;
use tokio::net::TcpListener;

#[derive(Clone)]
struct AppState {
    // Add your state here (database pools, etc.)
}

#[derive(Serialize)]
struct HealthResponse {
    status: String,
    version: String,
}

#[derive(Deserialize)]
struct CreateRequest {
    name: String,
}

#[derive(Serialize)]
struct CreateResponse {
    id: u64,
    name: String,
}

async fn health() -> Json<HealthResponse> {
    Json(HealthResponse {
        status: "healthy".to_string(),
        version: env!("CARGO_PKG_VERSION").to_string(),
    })
}

async fn create_item(
    State(_state): State<Arc<AppState>>,
    Json(payload): Json<CreateRequest>,
) -> Result<Json<CreateResponse>, StatusCode> {
    // Your business logic here
    Ok(Json(CreateResponse {
        id: 1,
        name: payload.name,
    }))
}

#[tokio::main]
async fn main() -> anyhow::Result<()> {
    env_logger::init();
    
    let state = Arc::new(AppState {
        // Initialize your state
    });
    
    let app = Router::new()
        .route("/health", get(health))
        .route("/items", post(create_item))
        .with_state(state);
    
    let listener = TcpListener::bind("127.0.0.1:3000").await?;
    log::info!("Server starting on http://127.0.0.1:3000");
    
    axum::serve(listener, app).await?;
    Ok(())
}
]],
    },
  },
}

-- =============================================================================
-- TEMPLATE PROCESSING
-- =============================================================================

local function substitute_variables(content, variables)
  local result = content
  for key, value in pairs(variables) do
    result = result:gsub("{{" .. key .. "}}", value)
  end
  return result
end

local function pascal_case(str)
  return str:gsub("[-_](%w)", function(c) return c:upper() end):gsub("^%w", string.upper)
end

local function create_project_from_template(template_name, project_name, project_path)
  local template = templates[template_name]
  if not template then
    vim.notify("Template not found: " .. template_name, vim.log.levels.ERROR)
    return
  end
  
  -- Create project directory
  vim.fn.mkdir(project_path, "p")
  
  -- Variables for substitution
  local variables = {
    PROJECT_NAME = project_name,
    PROJECT_NAME_PASCAL = pascal_case(project_name),
  }
  
  -- Create Cargo.toml
  local cargo_toml = {
    "[package]",
    'name = "' .. project_name .. '"',
    'version = "0.1.0"',
    'edition = "2021"',
    "",
    "[dependencies]",
  }
  
  for _, dep in ipairs(template.dependencies or {}) do
    table.insert(cargo_toml, dep)
  end
  
  if template.dev_dependencies then
    table.insert(cargo_toml, "")
    table.insert(cargo_toml, "[dev-dependencies]")
    for _, dep in ipairs(template.dev_dependencies) do
      table.insert(cargo_toml, dep)
    end
  end
  
  vim.fn.writefile(cargo_toml, project_path .. "/Cargo.toml")
  
  -- Create source files
  for file_path, content in pairs(template.files) do
    local full_path = project_path .. "/" .. file_path
    local dir = vim.fn.fnamemodify(full_path, ":h")
    vim.fn.mkdir(dir, "p")
    
    local processed_content = substitute_variables(content, variables)
    vim.fn.writefile(vim.split(processed_content, "\n"), full_path)
  end
  
  -- Create additional structure
  vim.fn.mkdir(project_path .. "/src", "p")
  if template_name ~= "library" then
    vim.fn.mkdir(project_path .. "/tests", "p")
  end
  
  -- Create .gitignore
  local gitignore = {
    "/target",
    "Cargo.lock",
    "*.pdb",
    "*.orig",
    ".DS_Store",
    ".vscode/",
    ".idea/",
  }
  vim.fn.writefile(gitignore, project_path .. "/.gitignore")
  
  -- Create README.md
  local readme = {
    "# " .. project_name,
    "",
    template.description,
    "",
    "## Usage",
    "",
    "```bash",
    "cargo run",
    "```",
    "",
    "## Testing",
    "",
    "```bash",
    "cargo test",
    "```",
    "",
    "## Development",
    "",
    "```bash",
    "cargo clippy",
    "cargo fmt",
    "```",
  }
  vim.fn.writefile(readme, project_path .. "/README.md")
  
  vim.notify("Created project: " .. project_name .. " at " .. project_path, vim.log.levels.INFO)
end

-- =============================================================================
-- CI/CD TEMPLATES
-- =============================================================================

local function create_github_actions(project_path)
  local workflows_dir = project_path .. "/.github/workflows"
  vim.fn.mkdir(workflows_dir, "p")
  
  local ci_yaml = [[
name: CI

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]

env:
  CARGO_TERM_COLOR: always

jobs:
  test:
    name: Test
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v4
    
    - name: Install Rust
      uses: dtolnay/rust-toolchain@stable
      with:
        components: rustfmt, clippy
    
    - name: Cache dependencies
      uses: actions/cache@v3
      with:
        path: |
          ~/.cargo/registry
          ~/.cargo/git
          target
        key: ${{ runner.os }}-cargo-${{ hashFiles('**/Cargo.lock') }}
    
    - name: Check formatting
      run: cargo fmt --all -- --check
    
    - name: Run clippy
      run: cargo clippy --all-targets --all-features -- -D warnings
    
    - name: Run tests
      run: cargo test --all-features
    
    - name: Run doc tests
      run: cargo test --doc
    
    - name: Build release
      run: cargo build --release --all-features

  security:
    name: Security audit
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v4
    
    - name: Install Rust
      uses: dtolnay/rust-toolchain@stable
    
    - name: Cache dependencies
      uses: actions/cache@v3
      with:
        path: |
          ~/.cargo/registry
          ~/.cargo/git
          target
        key: ${{ runner.os }}-cargo-${{ hashFiles('**/Cargo.lock') }}
    
    - name: Install cargo-audit
      run: cargo install cargo-audit
    
    - name: Run audit
      run: cargo audit
]]
  
  vim.fn.writefile(vim.split(ci_yaml, "\n"), workflows_dir .. "/ci.yml")
  
  local release_yaml = [[
name: Release

on:
  release:
    types: [published]

env:
  CARGO_TERM_COLOR: always

jobs:
  release:
    name: Release
    runs-on: ${{ matrix.os }}
    strategy:
      matrix:
        os: [ubuntu-latest, windows-latest, macos-latest]
    
    steps:
    - uses: actions/checkout@v4
    
    - name: Install Rust
      uses: dtolnay/rust-toolchain@stable
    
    - name: Cache dependencies
      uses: actions/cache@v3
      with:
        path: |
          ~/.cargo/registry
          ~/.cargo/git
          target
        key: ${{ runner.os }}-cargo-${{ hashFiles('**/Cargo.lock') }}
    
    - name: Build release
      run: cargo build --release
    
    - name: Create archive
      shell: bash
      run: |
        if [ "${{ matrix.os }}" = "windows-latest" ]; then
          7z a release.zip target/release/*.exe
        else
          tar czf release.tar.gz target/release/$(basename $(pwd))
        fi
    
    - name: Upload release asset
      uses: actions/upload-release-asset@v1
      env:
        GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
      with:
        upload_url: ${{ github.event.release.upload_url }}
        asset_path: ./release.*
        asset_name: ${{ matrix.os }}-release
        asset_content_type: application/octet-stream
]]
  
  vim.fn.writefile(vim.split(release_yaml, "\n"), workflows_dir .. "/release.yml")
  
  vim.notify("Created GitHub Actions workflows", vim.log.levels.INFO)
end

-- =============================================================================
-- DEVELOPMENT CONFIGURATION
-- =============================================================================

local function create_dev_config(project_path)
  -- Create .cargo/config.toml
  local cargo_dir = project_path .. "/.cargo"
  vim.fn.mkdir(cargo_dir, "p")
  
  local config_toml = [[
[build]
rustflags = ["-C", "link-arg=-fuse-ld=lld"]

[target.x86_64-unknown-linux-gnu]
linker = "clang"
rustflags = ["-C", "link-arg=-fuse-ld=lld"]

[target.x86_64-apple-darwin]
rustflags = ["-C", "link-arg=-fuse-ld=lld"]

[alias]
b = "build"
c = "check"
t = "test"
r = "run"
rr = "run --release"
]]
  
  vim.fn.writefile(vim.split(config_toml, "\n"), cargo_dir .. "/config.toml")
  
  -- Create deny.toml for cargo-deny
  local deny_toml = [[
[graph]
targets = [
    "x86_64-unknown-linux-gnu",
    "x86_64-apple-darwin",
    "x86_64-pc-windows-msvc",
]

[advisories]
vulnerability = "deny"
unmaintained = "warn"
unsound = "warn"
yanked = "warn"
notice = "warn"

[licenses]
unlicensed = "deny"
allow = [
    "MIT",
    "Apache-2.0",
    "Apache-2.0 WITH LLVM-exception",
    "BSD-2-Clause",
    "BSD-3-Clause",
    "ISC",
    "Unicode-DFS-2016",
]
deny = [
    "GPL-2.0",
    "GPL-3.0",
    "AGPL-1.0",
    "AGPL-3.0",
]

[bans]
multiple-versions = "warn"
wildcards = "allow"
highlight = "all"
]]
  
  vim.fn.writefile(vim.split(deny_toml, "\n"), project_path .. "/deny.toml")
  
  -- Create rustfmt.toml
  local rustfmt_toml = [[
edition = "2021"
max_width = 100
tab_spaces = 4
newline_style = "Unix"
use_small_heuristics = "Default"
reorder_imports = true
reorder_modules = true
remove_nested_parens = true
merge_derives = true
use_try_shorthand = true
use_field_init_shorthand = true
force_explicit_abi = true
]]
  
  vim.fn.writefile(vim.split(rustfmt_toml, "\n"), project_path .. "/rustfmt.toml")
  
  vim.notify("Created development configuration files", vim.log.levels.INFO)
end

-- =============================================================================
-- USER INTERFACE
-- =============================================================================

local function create_new_project()
  -- Get template choice
  local template_names = {}
  local template_descriptions = {}
  
  for name, template in pairs(templates) do
    table.insert(template_names, name)
    table.insert(template_descriptions, template.name .. " - " .. template.description)
  end
  
  vim.ui.select(template_descriptions, {
    prompt = "Select project template:",
  }, function(choice, idx)
    if not choice then return end
    
    local template_name = template_names[idx]
    
    -- Get project name
    local project_name = vim.fn.input("Project name: ")
    if project_name == "" then
      return
    end
    
    -- Get project path
    local default_path = vim.fn.getcwd() .. "/" .. project_name
    local project_path = vim.fn.input("Project path: ", default_path)
    if project_path == "" then
      return
    end
    
    -- Create project
    create_project_from_template(template_name, project_name, project_path)
    
    -- Ask for additional setup
    local setup_ci = vim.fn.confirm("Setup GitHub Actions CI/CD?", "&Yes\n&No", 2)
    if setup_ci == 1 then
      create_github_actions(project_path)
    end
    
    local setup_dev = vim.fn.confirm("Setup development configuration?", "&Yes\n&No", 1)
    if setup_dev == 1 then
      create_dev_config(project_path)
    end
    
    -- Initialize git
    local init_git = vim.fn.confirm("Initialize git repository?", "&Yes\n&No", 1)
    if init_git == 1 then
      vim.fn.system("cd " .. project_path .. " && git init")
      vim.notify("Initialized git repository", vim.log.levels.INFO)
    end
    
    -- Open project
    local open_project = vim.fn.confirm("Open project in new tab?", "&Yes\n&No", 1)
    if open_project == 1 then
      vim.cmd("tabnew " .. project_path .. "/src/main.rs")
    end
  end)
end

-- =============================================================================
-- WORKSPACE MANAGEMENT
-- =============================================================================

local function create_workspace()
  local workspace_name = vim.fn.input("Workspace name: ")
  if workspace_name == "" then
    return
  end
  
  local workspace_path = vim.fn.input("Workspace path: ", vim.fn.getcwd() .. "/" .. workspace_name)
  if workspace_path == "" then
    return
  end
  
  vim.fn.mkdir(workspace_path, "p")
  
  -- Create Cargo.toml for workspace
  local cargo_toml = {
    "[workspace]",
    "members = [",
    '    "crates/*",',
    "]",
    "",
    "[workspace.package]",
    'version = "0.1.0"',
    'edition = "2021"',
    'license = "MIT OR Apache-2.0"',
    "",
    "[workspace.dependencies]",
    "# Shared dependencies go here",
  }
  
  vim.fn.writefile(cargo_toml, workspace_path .. "/Cargo.toml")
  vim.fn.mkdir(workspace_path .. "/crates", "p")
  
  create_dev_config(workspace_path)
  create_github_actions(workspace_path)
  
  vim.notify("Created workspace: " .. workspace_name, vim.log.levels.INFO)
end

-- =============================================================================
-- SETUP FUNCTION
-- =============================================================================

function M.setup()
  -- Create user commands
  vim.api.nvim_create_user_command("RustNewProject", create_new_project, {
    desc = "Create new Rust project from template"
  })
  
  vim.api.nvim_create_user_command("RustNewWorkspace", create_workspace, {
    desc = "Create new Rust workspace"
  })
  
  vim.api.nvim_create_user_command("RustSetupCI", function()
    local project_path = vim.fn.finddir(".git", ".;"):gsub("/.git$", "")
    if project_path == "" then
      vim.notify("Not in a git repository", vim.log.levels.ERROR)
      return
    end
    create_github_actions(project_path)
  end, {
    desc = "Setup GitHub Actions CI/CD"
  })
  
  vim.api.nvim_create_user_command("RustSetupDev", function()
    local project_path = vim.fn.findfile("Cargo.toml", ".;"):gsub("/Cargo.toml$", "")
    if project_path == "" then
      vim.notify("Not in a Rust project", vim.log.levels.ERROR)
      return
    end
    create_dev_config(project_path)
  end, {
    desc = "Setup development configuration"
  })
end

return {
  "dummy/rust-project-templates",
  dir = vim.fn.stdpath("config") .. "/lua/aw/plugins/",
  config = function()
    require("aw.plugins.rust-project-templates").setup()
  end,
  
  -- Keymappings using <leader>rw* prefix (rust + workflow)
  keys = {
    { "<leader>rwn", "<cmd>RustNewProject<cr>", desc = "New Rust project" },
    { "<leader>rww", "<cmd>RustNewWorkspace<cr>", desc = "New Rust workspace" },
    { "<leader>rwc", "<cmd>RustSetupCI<cr>", desc = "Setup CI/CD" },
    { "<leader>rwd", "<cmd>RustSetupDev<cr>", desc = "Setup dev config" },
  },
}