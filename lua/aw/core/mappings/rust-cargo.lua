-- =============================================================================
-- Rust & Cargo Keymappings
-- =============================================================================
-- Comprehensive Rust development shortcuts using safe <leader>r* prefix
-- Features: Cargo commands, rustaceanvim integration, project management
-- Terminal: Uses WezTerm panes for better workflow integration

local map = vim.keymap.set

-- Helper function to run commands in WezTerm pane
local function wezterm_run(cmd, desc)
  return function()
    local full_cmd = "wezterm cli split-pane --right -- " .. cmd
    vim.fn.system(full_cmd)
  end
end

-- Helper function for commands that need user input
local function wezterm_input_run(prompt, cmd_template, desc)
  return function()
    local input = vim.fn.input(prompt)
    if input ~= "" then
      local cmd = string.format(cmd_template, input)
      local full_cmd = "wezterm cli split-pane --right -- " .. cmd
      vim.fn.system(full_cmd)
    end
  end
end

-- =============================================================================
-- CARGO COMMANDS (using <leader>rb* for build-related operations)
-- =============================================================================

-- Basic cargo operations
map("n", "<leader>rbb", wezterm_run("cargo build", "Cargo build"), { desc = "Cargo build" })
map("n", "<leader>rbr", wezterm_run("cargo build --release", "Cargo build release"), { desc = "Cargo build release" })
map("n", "<leader>rbc", wezterm_run("cargo check", "Cargo check"), { desc = "Cargo check" })
map("n", "<leader>rbC", wezterm_run("cargo clean", "Cargo clean"), { desc = "Cargo clean" })

-- Run operations
map("n", "<leader>rrr", wezterm_run("cargo run", "Cargo run"), { desc = "Cargo run" })
map("n", "<leader>rrR", wezterm_run("cargo run --release", "Cargo run release"), { desc = "Cargo run release" })
map("n", "<leader>rre", wezterm_input_run("Example name: ", "cargo run --example %s", "Cargo run example"), { desc = "Cargo run example" })

-- =============================================================================
-- CARGO NEXTEST TESTING (using <leader>rt* for test operations)
-- =============================================================================

-- Main test runners with cargo nextest
map("n", "<leader>rta", function()
  vim.cmd("split | resize 25 | terminal cargo nextest run --workspace")
  vim.cmd("startinsert")
  vim.notify("Running all workspace tests with nextest", vim.log.levels.INFO)
end, { desc = "Run all workspace tests (nextest)" })

map("n", "<leader>rtt", function()
  local current_file = vim.fn.expand('%:t:r') -- Get filename without extension
  if current_file and current_file ~= '' then
    vim.cmd("split | resize 25 | terminal cargo nextest run " .. current_file)
    vim.cmd("startinsert")
    vim.notify("Running tests for: " .. current_file, vim.log.levels.INFO)
  else
    vim.notify("No current file detected", vim.log.levels.WARN)
  end
end, { desc = "Run current file tests (nextest)" })

map("n", "<leader>rtf", function()
  local current_file = vim.fn.expand('%:t:r')
  if current_file and current_file ~= '' then
    vim.cmd("split | resize 25 | terminal cargo nextest run " .. current_file)
    vim.cmd("startinsert")
    vim.notify("Running file tests: " .. current_file, vim.log.levels.INFO)
  else
    vim.notify("No current file detected", vim.log.levels.WARN)
  end
end, { desc = "Run current file tests (nextest)" })

map("n", "<leader>rtl", function()
  vim.cmd("split | resize 25 | terminal cargo nextest run --workspace")
  vim.cmd("startinsert")
  vim.notify("Re-running workspace tests", vim.log.levels.INFO)
end, { desc = "Run last test (nextest)" })

-- Additional test types
map("n", "<leader>rtD", function() 
  vim.cmd("split | resize 25 | terminal cargo test --doc --workspace")
  vim.cmd("startinsert")
  vim.notify("Running doc tests for workspace", vim.log.levels.INFO)
end, { desc = "Run doc tests" })

map("n", "<leader>rti", function()
  vim.cmd("split | resize 25 | terminal cargo nextest run --workspace --ignored")
  vim.cmd("startinsert")
  vim.notify("Running ignored tests", vim.log.levels.INFO)
end, { desc = "Run ignored tests (nextest)" })

map("n", "<leader>rtv", function()
  vim.cmd("split | resize 30 | terminal cargo nextest run --workspace --verbose")
  vim.cmd("startinsert")
  vim.notify("Running tests with verbose output", vim.log.levels.INFO)
end, { desc = "Run tests verbose (nextest)" })

map("n", "<leader>rts", function()
  local test_name = vim.fn.input("Test filter (name/pattern): ")
  if test_name and test_name ~= '' then
    vim.cmd("split | resize 25 | terminal cargo nextest run --workspace " .. test_name)
    vim.cmd("startinsert")
    vim.notify("Running filtered tests: " .. test_name, vim.log.levels.INFO)
  end
end, { desc = "Run specific test (filter)" })

map("n", "<leader>rtp", function()
  local package = vim.fn.input("Package name: ")
  if package and package ~= '' then
    vim.cmd("split | resize 25 | terminal cargo nextest run --package " .. package)
    vim.cmd("startinsert")
    vim.notify("Running tests for package: " .. package, vim.log.levels.INFO)
  end
end, { desc = "Run package tests (nextest)" })

map("n", "<leader>rtr", function()
  vim.cmd("split | resize 25 | terminal cargo nextest run --workspace --release")
  vim.cmd("startinsert")
  vim.notify("Running tests in release mode", vim.log.levels.INFO)
end, { desc = "Run tests release (nextest)" })

map("n", "<leader>rtL", function()
  vim.cmd("split | resize 20 | terminal cargo nextest list --workspace")
  vim.cmd("startinsert")
  vim.notify("Listing all tests in workspace", vim.log.levels.INFO)
end, { desc = "List all tests (nextest)" })

map("n", "<leader>rtC", function()
  vim.cmd("split | resize 30 | terminal cargo llvm-cov nextest --workspace --html")
  vim.cmd("startinsert")
  vim.notify("Running tests with coverage", vim.log.levels.INFO)
end, { desc = "Run tests with coverage" })

-- Legacy cargo test commands for compatibility
map("n", "<leader>rtb", wezterm_run("cargo test --bins", "Cargo test bins"), { desc = "Cargo test bins" })
map("n", "<leader>rtu", wezterm_run("cargo test --lib", "Cargo test lib"), { desc = "Cargo test lib" })



-- Code quality operations
map("n", "<leader>rll", wezterm_run("cargo clippy", "Cargo clippy"), { desc = "Cargo clippy" })
map("n", "<leader>rlf", wezterm_run("cargo clippy --fix", "Cargo clippy fix"), { desc = "Cargo clippy fix" })
map("n", "<leader>rla", wezterm_run("cargo clippy --all-targets", "Cargo clippy all targets"), { desc = "Cargo clippy all targets" })
map("n", "<leader>rff", wezterm_run("cargo fmt", "Cargo format"), { desc = "Cargo format" })
map("n", "<leader>rfc", wezterm_run("cargo fmt --check", "Cargo format check"), { desc = "Cargo format check" })

-- Documentation operations
map("n", "<leader>rdd", wezterm_run("cargo doc", "Cargo doc"), { desc = "Cargo doc" })
map("n", "<leader>rdo", wezterm_run("cargo doc --open", "Cargo doc open"), { desc = "Cargo doc open" })
map("n", "<leader>rdp", wezterm_run("cargo doc --no-deps --open", "Cargo doc project only"), { desc = "Cargo doc project only" })
map("n", "<leader>rdt", wezterm_run("cargo test --doc", "Cargo doc tests"), { desc = "Cargo doc tests" })

-- Dependency management
map("n", "<leader>ruu", wezterm_run("cargo update", "Cargo update"), { desc = "Cargo update" })
map("n", "<leader>rut", wezterm_run("cargo tree", "Cargo dependency tree"), { desc = "Cargo dependency tree" })
map("n", "<leader>rua", wezterm_run("cargo audit", "Cargo audit"), { desc = "Cargo audit" })

-- Benchmarking and profiling
map("n", "<leader>rBb", wezterm_run("cargo bench", "Cargo benchmark"), { desc = "Cargo benchmark" })
map("n", "<leader>rBt", wezterm_run("cargo test --release", "Cargo test release"), { desc = "Cargo test release" })

-- =============================================================================
-- RUSTACEANVIM INTEGRATION (using <leader>rh* for hover/help actions)
-- =============================================================================

map("n", "<leader>rhh", "<cmd>RustLsp hover actions<cr>", { desc = "Rust hover actions" })
map("n", "<leader>rha", "<cmd>RustLsp codeAction<cr>", { desc = "Rust code actions" })
map("n", "<leader>rhR", "<cmd>RustLsp runnables<cr>", { desc = "Rust runnables" })
map("n", "<leader>rhD", "<cmd>RustLsp debuggables<cr>", { desc = "Rust debuggables" })
map("n", "<leader>rhm", "<cmd>RustLsp expandMacro<cr>", { desc = "Expand macro" })
map("n", "<leader>rhg", "<cmd>RustLsp crateGraph<cr>", { desc = "Crate graph" })
map("n", "<leader>rhe", "<cmd>RustLsp explainError<cr>", { desc = "Explain error" })
map("n", "<leader>rhw", "<cmd>RustLsp workspaceSymbol<cr>", { desc = "Workspace symbols" })
map("n", "<leader>rhr", "<cmd>RustLsp reloadWorkspace<cr>", { desc = "Reload workspace" })
map("n", "<leader>rhs", "<cmd>RustLsp ssr<cr>", { desc = "Structural search replace" })

-- =============================================================================
-- PROJECT MANAGEMENT (using <leader>rp* for project operations)
-- =============================================================================

-- Create new projects
map("n", "<leader>rpn", wezterm_input_run("Project name: ", "cargo new %s && cd %s", "New Rust project"), { desc = "New Rust project" })
map("n", "<leader>rpl", wezterm_input_run("Library name: ", "cargo new --lib %s && cd %s", "New Rust library"), { desc = "New Rust library" })

-- Add dependencies
map("n", "<leader>rpa", wezterm_input_run("Crate name: ", "cargo add %s", "Add crate dependency"), { desc = "Add crate dependency" })
map("n", "<leader>rpd", wezterm_input_run("Dev crate name: ", "cargo add --dev %s", "Add dev dependency"), { desc = "Add dev dependency" })

-- Workspace operations
map("n", "<leader>rpw", wezterm_run("cargo workspaces list", "List workspaces"), { desc = "List workspaces" })
map("n", "<leader>rpi", wezterm_run("cargo install --path .", "Install current project"), { desc = "Install current project" })

-- =============================================================================
-- RUST-SPECIFIC TELESCOPE SEARCHES (using <leader>rf* for find operations)
-- =============================================================================

map("n", "<leader>rff", "<cmd>Telescope find_files search_dirs={\"src/\"} prompt_title=\"Rust Files\"<cr>", { desc = "Find Rust files" })
map("n", "<leader>rfs", "<cmd>Telescope live_grep search_dirs={\"src/\"} prompt_title=\"Search Rust Code\"<cr>", { desc = "Search in Rust code" })
map("n", "<leader>rfr", "<cmd>Telescope lsp_references<cr>", { desc = "Find references" })
map("n", "<leader>rfi", "<cmd>Telescope lsp_implementations<cr>", { desc = "Find implementations" })
map("n", "<leader>rfd", "<cmd>Telescope lsp_definitions<cr>", { desc = "Find definitions" })
map("n", "<leader>rft", "<cmd>Telescope lsp_type_definitions<cr>", { desc = "Find type definitions" })

-- =============================================================================
-- COVERAGE AND PROFILING (using <leader>rC* for coverage operations)
-- =============================================================================

map("n", "<leader>rCc", wezterm_run("cargo tarpaulin --out Html", "Generate coverage report"), { desc = "Generate coverage report" })
map("n", "<leader>rCo", "<cmd>!open tarpaulin-report.html<cr>", { desc = "Open coverage report" })
map("n", "<leader>rCx", wezterm_run("cargo tarpaulin --out Xml", "Coverage XML"), { desc = "Coverage XML" })

-- =============================================================================
-- PERFORMANCE AND OPTIMIZATION (using <leader>rP* for performance)
-- =============================================================================

map("n", "<leader>rPf", wezterm_input_run("Binary name: ", "cargo build --release && perf record --call-graph=dwarf target/release/%s", "Profile with perf"), { desc = "Profile with perf" })
map("n", "<leader>rPs", wezterm_run("cargo bloat --release", "Analyze binary size"), { desc = "Analyze binary size" })
map("n", "<leader>rPt", wezterm_run("cargo bloat --release --time", "Analyze compile time"), { desc = "Analyze compile time" })

-- =============================================================================
-- QUICK ACTIONS (single letter shortcuts for most common operations)
-- =============================================================================

-- Most commonly used commands get single-letter shortcuts
map("n", "<leader>rR", wezterm_run("cargo run", "Quick: Cargo run"), { desc = "Quick: Cargo run" })
map("n", "<leader>rB", wezterm_run("cargo build", "Quick: Cargo build"), { desc = "Quick: Cargo build" })
map("n", "<leader>rT", wezterm_run("cargo test", "Quick: Cargo test"), { desc = "Quick: Cargo test" })
map("n", "<leader>rL", wezterm_run("cargo clippy", "Quick: Cargo clippy"), { desc = "Quick: Cargo clippy" })
map("n", "<leader>rF", wezterm_run("cargo fmt", "Quick: Cargo format"), { desc = "Quick: Cargo format" })
map("n", "<leader>rC", wezterm_run("cargo check", "Quick: Cargo check"), { desc = "Quick: Cargo check" })