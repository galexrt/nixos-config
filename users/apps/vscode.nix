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
    # Make sure to use the open source vscodium
    package = pkgs.vscodium-fhs;
    enableUpdateCheck = false;
    extensions = with pkgs.vscode-extensions; [
      mads-hartmann.bash-ide-vscode
      #betterComments
      #betterJinja
      naumovs.color-highlight
      firefox-devtools.vscode-firefox-debug
      vscjava.vscode-java-debug
      editorconfig.editorconfig
      #encodeDecode
      usernamehw.errorlens
      dbaeumer.vscode-eslint
      #formattingToggle
      eamodio.gitlens
      golang.go
      #grammarly
      hashicorp.terraform
      #moalamriInlineFold
      lokalise.i18n-ally
      #javascriptEs6CodeSnippets
      redhat.java
      ritwickdey.liveserver
      #javaLombok
      sumneko.lua
      yzhang.markdown-all-in-one
      bierner.markdown-mermaid
      jnoortheen.nix-ide
      #packageJsonUpgrade
      bmewburn.vscode-intelephense-client
      esbenp.prettier-vscode
      #prettyTSErrors
      ms-python.python
      #selectedLinesCount
      timonwong.shellcheck
      #vscodeLuaFormat
      zxh404.vscode-proto3
      #vueVolar
      redhat.vscode-xml
      redhat.vscode-yaml
    ];
    userSettings = {
      "workbench.startupEditor" = "none";
      "editor.fontFamily" = "Hack, 'Noto Color Emoji'";
      "markdown.preview.fontSize" = 8;
      "terminal.integrated.fontSize" = 8;
      "scm.inputFontSize" = 10;
      "editor.codeLensFontSize" = 8;
      "notebook.markup.fontSize" = 10;
      "workbench.colorTheme" = "Default High Contrast";
      "redhat.telemetry.enabled" = false;
      "explorer.confirmDelete" = false;
      "git.confirmSync" = false;
      "git.autofetch" = true;
      "[markdown]" = {
        "editor.defaultFormatter" = "yzhang.markdown-all-in-one";
      };
      "explorer.confirmDragAndDrop" = false;
      "explorer.openEditors.visible" = 0;
      "git.enableCommitSigning" = true;
      "git.alwaysSignOff" = true;
      "[yaml]" = {
        "editor.defaultFormatter" = "esbenp.prettier-vscode";
      };
      "[javascript]" = {
        "editor.defaultFormatter" = "esbenp.prettier-vscode";
      };
      "[html]" = {
        "editor.defaultFormatter" = "esbenp.prettier-vscode";
      };
      "markdown.extension.toc.levels" = "2..6";
      "markdown.extension.toc.unorderedList.marker" = "*";
      "[scss]" = {
        "editor.defaultFormatter" = "esbenp.prettier-vscode";
      };
      "editor.largeFileOptimizations" = false;
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
      "go.toolsManagement.autoUpdate" = true;
      "go.gopath" = "${config.home.homeDirectory}/Projects/go";
      "java.referencesCodeLens.enabled" = true;
      "java.codeGeneration.generateComments" = true;
      "java.configuration.runtimes" = [
        {
          "name" = "JavaSE-19";
          "path" = "/usr/lib/jvm/java-19-openjdk";
        }
        {
          "name" = "JavaSE-17";
          "path" = "/usr/lib/jvm/java-17-openjdk";
        }
        {
          "name" = "JavaSE-11";
          "path" = "/usr/lib/jvm/java-11-openjdk";
        }
      ];
      "intelephense.environment.phpVersion" = "7.4.16";
      "editor.quickSuggestions" = {
        "comments" = "on";
        "strings" = "on";
      };
      "debug.console.fontSize" = 10;
      "json.format.keepLines" = true;
      "[vue]" = {
        "editor.defaultFormatter" = "Vue.volar";
      };
      "update.showReleaseNotes" = false;
      "editor.formatOnPaste" = false;
      "editor.formatOnSave" = false;
      "editor.formatOnType" = false;
      "terminal.integrated.persistentSessionReviveProcess" = "never";
      "terminal.integrated.enablePersistentSessions" = false;
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
      "diffEditor.ignoreTrimWhitespace" = false;
      "volar.format.initialIndent" = {
        "html" = true;
      };
      "i18n-ally.displayLanguage" = "en-US";
      "[lua]" = {
        "editor.defaultFormatter" = "sumneko.lua";
      };
      "editor.fontSize" = 8;
    };
  };
}
