# Opiate for the masses

A data science blog built with [Jekyll 4](https://jekyllrb.com/) and the [Minimal Mistakes](https://mmistakes.github.io/minimal-mistakes/) theme.

Live at **[quiri.github.io](https://quiri.github.io)**

## Local Development

### Prerequisites

- [Ruby](https://www.ruby-lang.org/) >= 3.0
- [Bundler](https://bundler.io/) (`gem install bundler`)

### Setup

```bash
# Install dependencies
bundle install

# Start local dev server (with live reload)
bundle exec jekyll serve --livereload
```

The site will be available at `http://localhost:4000`.

## Writing Posts

1. Create a new Markdown file in `_posts/` following the naming convention:
   ```
   YYYY-MM-DD-your-post-title.md
   ```

2. Add the required frontmatter:
   ```yaml
   ---
   layout: post
   title: "Your Post Title"
   excerpt: "A short description"
   categories: articles
   tags: [R, ggplot2]
   author: kirill
   date: 2026-01-01
   ---
   ```

3. Write your content in Markdown below the frontmatter.

### RMarkdown Posts

If you write posts in RMarkdown, use the Makefile workflow:

```bash
# Create a new .Rmd post
make new NAME="my-post-title"

# Render all .Rmd files to Markdown and copy to _posts/
make publish
```

## Deployment

Pushes to `master` or `main` automatically build and deploy via [GitHub Actions](/.github/workflows/deploy.yml). No manual deployment needed.

## Project Structure

```
├── _config.yml          # Site configuration
├── _data/
│   ├── authors.yml      # Author profiles
│   └── navigation.yml   # Top navigation links
├── _layouts/            # Layout wrappers (post, page → single)
├── _posts/              # Blog posts (Markdown)
├── _R/                  # RMarkdown source files
├── about/               # About page
├── articles/            # Articles archive page
├── tags/                # Tag index page
├── assets/css/          # Sass entry point
├── images/              # Post images
├── Gemfile              # Ruby dependencies
├── Makefile             # RMarkdown build helpers
└── .github/workflows/   # CI/CD (GitHub Actions)
```

## License

See [LICENSE](LICENSE) for details.
