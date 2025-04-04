{ config, pkgs, ... }:
let
  inherit (pkgs) vscode-utils;

  /*
    betterComments = vscode-utils.extensionFromVscodeMarketplace {
    url = "https://open-vsx.org/api/aaron-bond/better-comments/3.0.2/file/aaron-bond.better-comments-3.0.2.vsix";
    name = "better-comments";
    publisher = "aaron-bond";
    version = "3.0.2";
    sha256 = "sha256:0lhrw24ilncdczh90jnjx71ld3b626xpk8b9qmwgzzhby89qs417";
    };

    betterJinja = vscode-utils.extensionFromVscodeMarketplace {
    name = "jinjahtml";
    publisher = "samuelcolvin";
    version = "0.20.0";
    sha256 = "";
    };

    encodeDecode = vscode-utils.extensionFromVscodeMarketplace {
    name = "ecdc";
    publisher = "mitchdenny";
    version = "1.8.0";
    sha256 = "";
    };

    formattingToggle = vscode-utils.extensionFromVscodeMarketplace {
    name = "vscode-status-bar-format-toggle";
    publisher = "tombonnike";
    version = "3.1.1";
    sha256 = "";
    };

    grammarly = vscode-utils.extensionFromVscodeMarketplace {
    name = "grammarly";
    publisher = "znck";
    version = "0.22.1";
    sha256 = "";
    };

    javascriptEs6CodeSnippets = vscode-utils.extensionFromVscodeMarketplace {
    name = "JavaScriptSnippets";
    publisher = "xabikos";
    version = "1.8.0";
    sha256 = "";
    };

    javaLombok = vscode-utils.extensionFromVscodeMarketplace {
    name = "vscode-lombok";
    publisher = "GabrielBB";
    version = "1.0.1";
    sha256 = "";
    };

    packageJsonUpgrade = vscode-utils.extensionFromVscodeMarketplace {
    name = "package-json-upgrade";
    publisher = "codeandstuff";
    version = "2.0.0";
    sha256 = "";
    };

    prettyTSErrors = vscode-utils.extensionFromVscodeMarketplace {
    name = "pretty-ts-errors";
    publisher = "yoavbls";
    version = "0.2.8";
    sha256 = "";
    };

    selectedLinesCount = vscode-utils.extensionFromVscodeMarketplace {
    name = "selected-lines-count";
    publisher = "gurumukhi";
    version = "1.4.0";
    sha256 = "";
    };

    vscodeLuaFormat = vscode-utils.extensionFromVscodeMarketplace {
    name = "vscode-lua-format";
    publisher = "Koihik";
    version = "1.3.8";
    sha256 = "";
    };

    vueVolar = vscode-utils.extensionFromVscodeMarketplace {
    name = "volar";
    publisher = "Vue";
    version = "1.8.4";
    sha256 = "";
    };

    moalamriInlineFold = vscode-utils.extensionFromVscodeMarketplace {
    name = "inline-fold";
    publisher = "moalamri";
    version = "0.2.3";
    sha256 = "";
  };*/
in
{
  programs.vscode = {
    enable = true;
    package = pkgs.vscode-fhs;
    enableUpdateCheck = false;
    mutableExtensionsDir = true;

    #extensions = with pkgs.vscode-extensions; [
    #  mads-hartmann.bash-ide-vscode
    #  naumovs.color-highlight
    #  firefox-devtools.vscode-firefox-debug
    #  vscjava.vscode-java-debug
    #  editorconfig.editorconfig
    #  usernamehw.errorlens
    #  dbaeumer.vscode-eslint
    #  eamodio.gitlens
    #  golang.go
    #  hashicorp.terraform
    #  lokalise.i18n-ally
    #  redhat.java
    #  ritwickdey.liveserver
    #  sumneko.lua
    #  yzhang.markdown-all-in-one
    #  bierner.markdown-mermaid
    #  jnoortheen.nix-ide
    #  bmewburn.vscode-intelephense-client
    #  esbenp.prettier-vscode
    #  ms-python.python
    #  timonwong.shellcheck
    #  zxh404.vscode-proto3
    #  redhat.vscode-xml
    #  redhat.vscode-yaml
    #  #betterComments
    #  #betterJinja
    #  #encodeDecode
    #  #formattingToggle
    #  #grammarly
    #  #moalamriInlineFold
    #  #javascriptEs6CodeSnippets
    #  #javaLombok
    #  #packageJsonUpgrade
    #  #prettyTSErrors
    #  #selectedLinesCount
    #  #vscodeLuaFormat
    #  #vueVolar
    #];

    userSettings = {
      "clangd.path" = "/home/atrost/.config/VSCode/User/globalStorage/llvm-vs-code-extensions.vscode-clangd/install/18.1.3/clangd_18.1.3/bin/clangd";
      "debug.console.fontSize" = 10;
      "diffEditor.ignoreTrimWhitespace" = false;
      "editor.codeLensFontSize" = 8;
      "editor.fontFamily" = "Hack, 'Noto Color Emoji'";
      "editor.fontSize" = 10;
      "editor.formatOnPaste" = false;
      "editor.formatOnSave" = false;
      "editor.formatOnType" = false;
      "editor.largeFileOptimizations" = false;
      "editor.quickSuggestions" = {
        "comments" = "on";
        "strings" = "on";
      };
      "errorLens.enabled" = true;
      "explorer.confirmDelete" = false;
      "explorer.confirmDragAndDrop" = false;
      "explorer.openEditors.visible" = 0;
      "git.alwaysSignOff" = true;
      "git.autofetch" = true;
      "git.confirmSync" = false;
      "git.enableCommitSigning" = true;
      "go.gopath" = "${config.home.homeDirectory}/Projects/go";
      "go.toolsManagement.autoUpdate" = true;
      "gopls" = {
	      "formatting.gofumpt" = true;
      };
      "intelephense.environment.phpVersion" = "8.3.8";
      "java.codeGeneration.generateComments" = true;
      "java.configuration.runtimes" = [
        {
          "name" = "JavaSE-19";
          "path" = "/usr/lib/jvm/java-19-openjdk";
        }
      ];
      "java.referencesCodeLens.enabled" = true;
      "json.format.keepLines" = true;
      "markdown.preview.fontSize" = 8;
      "notebook.markup.fontSize" = 10;
      "redhat.telemetry.enabled" = false;
      "scm.inputFontSize" = 10;
      "terminal.integrated.enablePersistentSessions" = false;
      "terminal.integrated.fontSize" = 8;
      "terminal.integrated.persistentSessionReviveProcess" = "never";
      "update.showReleaseNotes" = false;
      "volar.format.initialIndent" = {
        "html" = true;
      };
      "workbench.colorTheme" = "Default High Contrast";
      "workbench.sideBar.location" = "left";
      "workbench.panel.defaultLocation" = "right";
      "workbench.startupEditor" = "none";

      # Make sure gitlens doesn't get on our nerves
      "gitlens.currentLine.pullRequests.enabled" = false;
      "gitlens.hovers.autolinks.enhanced" = false;
      "gitlens.hovers.pullRequests.enabled" = false;
      "gitlens.statusBar.pullRequests.enabled" = false;
      "gitlens.views.branches.pullRequests.enabled" = false;
      "gitlens.views.branches.pullRequests.showForBranches" = false;
      "gitlens.views.branches.pullRequests.showForCommits" = false;
      "gitlens.views.commits.pullRequests.enabled" = false;
      "gitlens.views.commits.pullRequests.showForBranches" = false;
      "gitlens.views.commits.pullRequests.showForCommits" = false;
      "gitlens.views.contributors.pullRequests.enabled" = false;
      "gitlens.views.contributors.pullRequests.showForCommits" = false;
      "gitlens.views.searchAndCompare.pullRequests.showForCommits" = false;
      "gitlens.views.searchAndCompare.pullRequests.enabled" = false;
      "gitlens.views.repositories.pullRequests.showForCommits" = false;
      "gitlens.views.repositories.pullRequests.showForBranches" = false;
      "gitlens.views.repositories.pullRequests.enabled" = false;
      "gitlens.views.remotes.pullRequests.showForCommits" = false;
      "gitlens.views.remotes.pullRequests.showForBranches" = false;
      "gitlens.views.remotes.pullRequests.enabled" = false;

      # Lanague specific
      "[markdown]" = {
        "editor.defaultFormatter" = "yzhang.markdown-all-in-one";
      };
      "[yaml]" = {
        "editor.defaultFormatter" = "esbenp.prettier-vscode";
      };
      "[javascript]" = {
        "editor.defaultFormatter" = "esbenp.prettier-vscode";
      };
      "[html]" = {
        "editor.defaultFormatter" = "esbenp.prettier-vscode";
      };
      "[scss]" = {
        "editor.defaultFormatter" = "esbenp.prettier-vscode";
      };
      "[json]" = {
        "editor.defaultFormatter" = "esbenp.prettier-vscode";
      };
      "[css]" = {
        "editor.defaultFormatter" = "vscode.css-language-features";
      };
      "[jsonc]" = {
        "editor.defaultFormatter" = "esbenp.prettier-vscode";
      };
      "[typescript]" = {
        "editor.defaultFormatter" = "esbenp.prettier-vscode";
      };
      "[vue]" = {
        "editor.defaultFormatter" = "Vue.volar";
      };
      "[lua]" = {
        "editor.defaultFormatter" = "sumneko.lua";
      };
    };
  };
}
