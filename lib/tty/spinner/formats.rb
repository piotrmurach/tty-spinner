# coding: utf-8

module TTY
  module Formats
    FORMATS = {
      classic: {
        interval: 10,
        frames: %w{| / - \\}
      },
      spin: {
        interval: 10,
        frames: %w{◴ ◷ ◶ ◵ }
      },
      spin_2: {
        interval: 10,
        frames: %w{◐ ◓ ◑ ◒ }
      },
      spin_3: {
        interval: 10,
        frames: %w{◰ ◳ ◲ ◱}
      },
      spin_4: {
        inteval: 10,
        frames: %w{╫ ╪'}
      },
      pulse: {
        interval: 10,
        frames: %w{⎺ ⎻ ⎼ ⎽ ⎼ ⎻}
      },
      pulse_2: {
        interval: 15,
        frames: %w{▁ ▃ ▅ ▆ ▇ █ ▇ ▆ ▅ ▃ }
      },
      pulse_3: {
        interval: 20,
        frames: '▉▊▋▌▍▎▏▎▍▌▋▊▉'
      },
      dots: {
        interval: 10,
        frames: [ "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" ]
      },
      arrow: {
        interval: 10,
        frames: %w{← ↖ ↑ ↗ → ↘ ↓ ↙ }
      },
      arrow_pulse: {
        interval: 10,
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
        interval: 10,
        frames: %w{◢ ◣ ◤ ◥}
      },
      arc: {
        interval: 10,
        frames: %w{ ◜ ◠ ◝ ◞ ◡ ◟ }
      },
      pipe: {
        interval: 10,
        frames: %w{ ┤ ┘ ┴ └ ├ ┌ ┬ ┐ }
      },
      bouncing: {
        interval: 10,
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
        interval: 10,
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
        interval: 10,
        frames: %w{ ▌ ▀ ▐ ▄  }
      },
      box_bounce_2: {
        interval: 10,
        frames: %w{ ▖ ▘ ▝ ▗ }
      },
      star: {
        interval: 10,
        frames: %w{ ✶ ✸ ✹ ✺ ✹ ✷ }
      },
      toggle: {
        interval: 10,
        frames: %w{ ■ □ ▪ ▫ }
      },
      balloon: {
        interval: 10,
        frames: %w{ . o O @ * }
      },
      balloon_2: {
        interval: 10,
        frames: %w{. o O ° O o . }
      },
      flip: {
        interval: 10,
        frames: '-◡⊙-◠'.freeze
      }
    }
  end # Formats
end # TTY
