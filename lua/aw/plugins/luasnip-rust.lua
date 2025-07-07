-- =============================================================================
-- Custom Rust Snippets for LuaSnip
-- =============================================================================
-- Advanced Rust patterns and productivity snippets beyond friendly-snippets
-- Features: Common patterns, test templates, error handling, async patterns

return {
  "L3MON4D3/LuaSnip",
  config = function()
    local ls = require("luasnip")
    local s = ls.snippet
    local t = ls.text_node
    local i = ls.insert_node
    local f = ls.function_node
    local c = ls.choice_node
    local fmt = require("luasnip.extras.fmt").fmt
    local rep = require("luasnip.extras").rep
    
    -- =============================================================================
    -- UTILITY FUNCTIONS
    -- =============================================================================
    
    -- Get current date for snippets
    local function date()
      return os.date("%Y-%m-%d")
    end
    
    -- Get the current filename without extension
    local function filename()
      return vim.fn.expand("%:t:r")
    end
    
    -- =============================================================================
    -- RUST SNIPPETS
    -- =============================================================================
    
    ls.add_snippets("rust", {
      
      -- ==========================================================================
      -- TYPE SHORTCUTS
      -- ==========================================================================
      s("res", fmt("Result<{}, {}>", { i(1, "T"), i(2, "Box<dyn Error>") })),
      s("opt", fmt("Option<{}>", { i(1, "T") })),
      s("vec", fmt("Vec<{}>", { i(1, "T") })),
      s("hm", fmt("HashMap<{}, {}>", { i(1, "K"), i(2, "V") })),
      s("hs", fmt("HashSet<{}>", { i(1, "T") })),
      s("bt", fmt("BTreeMap<{}, {}>", { i(1, "K"), i(2, "V") })),
      s("rc", fmt("Rc<{}>", { i(1, "T") })),
      s("arc", fmt("Arc<{}>", { i(1, "T") })),
      s("mutex", fmt("Arc<Mutex<{}>>", { i(1, "T") })),
      s("rwlock", fmt("Arc<RwLock<{}>>", { i(1, "T") })),
      
      -- ==========================================================================
      -- COMMON PATTERNS
      -- ==========================================================================
      
      -- Main function
      s("main", fmt([[
        fn main() -> Result<(), Box<dyn std::error::Error>> {{
            {}
            Ok(())
        }}
      ]], { i(1, "// TODO: implement") })),
      
      -- Async main
      s("amain", fmt([[
        #[tokio::main]
        async fn main() -> Result<(), Box<dyn std::error::Error>> {{
            {}
            Ok(())
        }}
      ]], { i(1, "// TODO: implement") })),
      
      -- Derive common traits
      s("der", fmt("#[derive({})]", { 
        c(1, {
          t("Debug"),
          t("Debug, Clone"),
          t("Debug, Clone, PartialEq"),
          t("Debug, Clone, PartialEq, Eq"),
          t("Debug, Clone, PartialEq, Eq, Hash"),
          t("Debug, Clone, Serialize, Deserialize"),
          i(nil, "Debug, Clone")
        })
      })),
      
      -- Struct definition with common derives
      s("struct", fmt([[
        #[derive(Debug, Clone{})]
        pub struct {} {{
            {}
        }}
      ]], { 
        c(1, { t(""), t(", PartialEq"), t(", PartialEq, Eq"), t(", Serialize, Deserialize") }),
        i(2, "Name"),
        i(3, "// fields")
      })),
      
      -- Enum definition
      s("enum", fmt([[
        #[derive(Debug, Clone{})]
        pub enum {} {{
            {}
        }}
      ]], { 
        c(1, { t(""), t(", PartialEq"), t(", PartialEq, Eq") }),
        i(2, "Name"),
        i(3, "// variants")
      })),
      
      -- ==========================================================================
      -- ERROR HANDLING
      -- ==========================================================================
      
      -- Custom error enum with thiserror
      s("error", fmt([[
        use thiserror::Error;
        
        #[derive(Error, Debug)]
        pub enum {}Error {{
            #[error("IO error: {{0}}")]
            Io(#[from] std::io::Error),
            
            #[error("{}")]
            Custom(String),
        }}
      ]], { i(1, "My"), rep(1) })),
      
      -- Result type alias
      s("result", fmt("pub type {}Result<T> = Result<T, {}Error>;", { i(1, "My"), rep(1) })),
      
      -- Error propagation patterns
      s("?", t("?")),
      s("mapErr", fmt(".map_err(|e| {})?", { i(1, "e.into()") })),
      s("unwrapOr", fmt(".unwrap_or_else(|_| {})", { i(1, "default_value") })),
      s("expect", fmt('.expect("{}")', { i(1, "error message") })),
      
      -- ==========================================================================
      -- TESTING
      -- ==========================================================================
      
      -- Basic test
      s("test", fmt([[
        #[test]
        fn {}() {{
            {}
        }}
      ]], { i(1, "test_name"), i(2, "// Test implementation") })),
      
      -- Test with Result
      s("testres", fmt([[
        #[test]
        fn {}() -> Result<(), Box<dyn std::error::Error>> {{
            {}
            Ok(())
        }}
      ]], { i(1, "test_name"), i(2, "// Test implementation") })),
      
      -- Async test
      s("atest", fmt([[
        #[tokio::test]
        async fn {}() {{
            {}
        }}
      ]], { i(1, "test_name"), i(2, "// Test implementation") })),
      
      -- Benchmark
      s("bench", fmt([[
        #[bench]
        fn {}(b: &mut test::Bencher) {{
            b.iter(|| {{
                {}
            }});
        }}
      ]], { i(1, "benchmark_name"), i(2, "// Code to benchmark") })),
      
      -- Test module
      s("testmod", fmt([[
        #[cfg(test)]
        mod tests {{
            use super::*;
            
            #[test]
            fn {}() {{
                {}
            }}
        }}
      ]], { i(1, "test_function"), i(2, "// Test implementation") })),
      
      -- ==========================================================================
      -- ASYNC PATTERNS
      -- ==========================================================================
      
      -- Async function
      s("afn", fmt("async fn {}({}) -> {} {{\n    {}\n}}", { 
        i(1, "function_name"), 
        i(2, ""), 
        i(3, "Result<(), Box<dyn Error>>"), 
        i(4, "todo!()") 
      })),
      
      -- Spawn task
      s("spawn", fmt("tokio::spawn(async move {{\n    {}\n}});", { i(1, "// async work") })),
      
      -- Join handles
      s("join", fmt([[
        let handles = vec![{}];
        let results = futures::future::try_join_all(handles).await?;
      ]], { i(1, "handle1, handle2") })),
      
      -- ==========================================================================
      -- ITERATORS AND FUNCTIONAL PATTERNS
      -- ==========================================================================
      
      -- Iterator chains
      s("iter", fmt("{}.iter()", { i(1, "collection") })),
      s("map", fmt(".map(|{}| {})", { i(1, "item"), i(2, "item") })),
      s("filter", fmt(".filter(|{}| {})", { i(1, "item"), i(2, "condition") })),
      s("collect", fmt(".collect::<{}>()", { i(1, "Vec<_>") })),
      s("fold", fmt(".fold({}, |acc, {}| {})", { i(1, "initial"), i(2, "item"), i(3, "acc + item") })),
      
      -- ==========================================================================
      -- MACRO PATTERNS
      -- ==========================================================================
      
      -- Println debugging
      s("pd", fmt('println!("{}: {{:?}}", {});', { i(1, "debug"), rep(1) })),
      s("pf", fmt('println!("{}", {});', { i(1, "message"), i(2, "value") })),
      
      -- Logging
      s("info", fmt('log::info!("{}");', { i(1, "message") })),
      s("warn", fmt('log::warn!("{}");', { i(1, "message") })),
      s("error", fmt('log::error!("{}");', { i(1, "message") })),
      s("debug", fmt('log::debug!("{}");', { i(1, "message") })),
      
      -- ==========================================================================
      -- COMMON IMPORTS
      -- ==========================================================================
      
      s("imports", fmt([[
        use std::{{
            collections::HashMap,
            error::Error,
            fs,
            io::{{self, BufRead, BufReader}},
        }};
        
        {}
      ]], { i(1, "// Additional imports") })),
      
      -- Serde imports
      s("serde", t("use serde::{Deserialize, Serialize};")),
      
      -- Tokio imports
      s("tokio", t("use tokio::{fs, io::{AsyncReadExt, AsyncWriteExt}};")),
      
      -- ==========================================================================
      -- DOCUMENTATION
      -- ==========================================================================
      
      -- Doc comment
      s("doc", fmt("/// {}", { i(1, "Documentation") })),
      
      -- Function documentation
      s("docfn", fmt([[
        /// {}
        ///
        /// # Arguments
        /// * `{}` - {}
        ///
        /// # Returns
        /// {}
        ///
        /// # Examples
        /// ```
        /// {}
        /// ```
      ]], { 
        i(1, "Brief description"), 
        i(2, "param"), 
        i(3, "Parameter description"),
        i(4, "Return description"),
        i(5, "example_usage()")
      })),
      
      -- ==========================================================================
      -- COMMON FUNCTIONS
      -- ==========================================================================
      
      -- Constructor
      s("new", fmt([[
        pub fn new({}) -> Self {{
            Self {{
                {}
            }}
        }}
      ]], { i(1, ""), i(2, "// fields") })),
      
      -- Default implementation
      s("default", fmt([[
        impl Default for {} {{
            fn default() -> Self {{
                Self::new({})
            }}
        }}
      ]], { i(1, "Type"), i(2, "") })),
      
      -- Display implementation
      s("display", fmt([[
        impl std::fmt::Display for {} {{
            fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {{
                write!(f, "{}")
            }}
        }}
      ]], { i(1, "Type"), i(2, "format string") })),
      
      -- From implementation
      s("from", fmt([[
        impl From<{}> for {} {{
            fn from(value: {}) -> Self {{
                {}
            }}
        }}
      ]], { i(1, "SourceType"), i(2, "TargetType"), rep(1), i(3, "Self { /* conversion */ }") })),
    })
  end,
}