# coding: utf-8

module TTY
  module Formats
    FORMATS = {
      classic: {
        frames: %w{| / - \\}
      },
      spin: {
        frames: %w{◴ ◷ ◶ ◵ }
      },
      spin_2: {
        frames: %w{◐ ◓ ◑ ◒ }
      },
      spin_3: {
        frames: %w{◰ ◳ ◲ ◱}
      },
      spin_4: {
        frames: %w{╫ ╪'}
      },
      pulse: {
        frames: %w{⎺ ⎻ ⎼ ⎽ ⎼ ⎻}
      },
      pulse_2: {
        frames: %w{▁ ▃ ▅ ▆ ▇ █ ▇ ▆ ▅ ▃ }
      },
      pulse_3: {
        frames: '▉▊▋▌▍▎▏▎▍▌▋▊▉'
      },
      dots: {
        frames: [ "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" ]
      },
      arrow: {
        frames: %w{← ↖ ↑ ↗ → ↘ ↓ ↙ }
      },
      arrow_pulse: {
        frames: [
          "▹▹▹▹▹",
          "▸▹▹▹▹",
          "▹▸▹▹▹",
          "▹▹▸▹▹",
          "▹▹▹▸▹",
          "▹▹▹▹▸"
        ]
      },
      triangle: {
        frames: %w{◢ ◣ ◤ ◥}
      },
      arc: {
        frames: %w{ ◜ ◠ ◝ ◞ ◡ ◟ }
      },
      pipe: {
        frames: %w{ ┤ ┘ ┴ └ ├ ┌ ┬ ┐ }
      },
      bouncing: {
        frames: [
          "[    ]",
          "[   =]",
          "[  ==]",
          "[ ===]",
          "[====]",
          "[=== ]",
          "[==  ]",
          "[=   ]"
        ]
      },
      bouncing_ball: {
        frames: [
          "( ●    )",
          "(  ●   )",
          "(   ●  )",
          "(    ● )",
          "(     ●)",
          "(    ● )",
          "(   ●  )",
          "(  ●   )",
          "( ●    )",
          "(●     )"
        ]
      },
      box_bounce: {
        frames: %w{ ▌ ▀ ▐ ▄  }
      },
      box_bounce_2: {
        frames: %w{ ▖ ▘ ▝ ▗ }
      },
      star: {
        frames: %w{ ✶ ✸ ✹ ✺ ✹ ✷ }
      },
      toggle: {
        frames: %w{ ■ □ ▪ ▫ }
      },
      balloon: {
        frames: %w{ . o O @ * }
      },
      balloon_2: {
        frames: %w{. o O ° O o . }
      },
      flip: {
        frames: '-◡⊙-◠'.freeze
      }
    }
  end # Formats
end # TTY
