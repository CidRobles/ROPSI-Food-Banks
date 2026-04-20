#!/bin/bash

# ─────────────────────────────────────────────
#  Gift Cart Setup Script
#  Run this from inside any website folder.
#  Requirements: index.html must exist there.
# ─────────────────────────────────────────────

set -e

# ── Check index.html exists ──────────────────
if [ ! -f "index.html" ]; then
    echo "❌  No index.html found in the current folder. Please run this script from inside the website folder."
    exit 1
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Gift Cart Setup"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# ── Static content ───────────────────────────
HEADING="Support all of the causes that you love, all with one gift."
SUBHEADING="Browse our programs, add what matters to you, and give to all of them with a single checkout."

# ── Prompt for inputs ────────────────────────
read -p "FundraiseUp anchor code for giftcart.html (e.g. #FUNPGVYPGRZ): " FU_ANCHOR
read -p "Image filename with extension (e.g. gift_cart_image.png): " IMAGE_FILE
read -p "Image folder path relative to index.html (e.g. assets or assets/img): " IMAGE_FOLDER
read -p "Insert new section AFTER which section id in index.html (e.g. featured-program): " AFTER_SECTION
read -p "Section id to DELETE from index.html (e.g. giving-cart) [leave blank to skip]: " DELETE_SECTION

IMAGE_PATH="${IMAGE_FOLDER}/${IMAGE_FILE}"

echo ""
echo "──────────────────────────────────────────────"
echo "  Settings"
  echo "  FundraiseUp anchor : $FU_ANCHOR"
  echo "  Image path         : $IMAGE_PATH"
  echo "  Heading            : $HEADING"
  echo "  Subheading         : $SUBHEADING"
  echo "  Insert after       : #$AFTER_SECTION"
echo "  Delete section     : #$DELETE_SECTION"
echo "──────────────────────────────────────────────"
echo ""
read -p "Looks good? Press Enter to continue or Ctrl+C to cancel..."

# ── Step 1: Clone index.html → giftcart.html ─
echo ""
echo "▶  Cloning index.html → giftcart.html..."
cp index.html giftcart.html

# ── Step 2: Strip all <main> sections except hero ──
python3 - <<PYEOF
import re

with open('giftcart.html', 'r') as f:
    content = f.read()

# Replace everything inside <main>...</main> with just a blank hero shell
new_main = '''    <main>
        <section id="hero">
            <div class="container">
                <h1 style="text-align: center; padding: 0 1.5rem;">${HEADING}</h1>
                <p style="text-align: center; padding: 0 1.5rem;">${SUBHEADING}</p>
                <a href="${FU_ANCHOR}" style="display: none"></a>
            </div>
        </section>
    </main>'''

content = re.sub(r'<main>.*?</main>', new_main, content, flags=re.DOTALL)

with open('giftcart.html', 'w') as f:
    f.write(content)

print("  ✓ Sections stripped, hero shell + FundraiseUp anchor injected.")
PYEOF

# ── Step 3: Inject hero background override style ──
python3 - <<PYEOF
with open('giftcart.html', 'r') as f:
    content = f.read()

override = '''    <style>
        #hero {
            background: none;
        }
        #hero .container {
            max-width: 100%;
            width: 100%;
            box-sizing: border-box;
            padding: 0 1.5rem;
        }
    </style>'''

# Insert before </head>
content = content.replace('</head>', override + '\n</head>')

with open('giftcart.html', 'w') as f:
    f.write(content)

print("  ✓ Hero background override injected.")
PYEOF

echo "  ✓ giftcart.html is ready."

# ── Step 4: Add new gift cart section to index.html ──
echo ""
echo "▶  Adding gift cart section to index.html after #${AFTER_SECTION}..."

python3 - <<PYEOF
import re

with open('index.html', 'r') as f:
    content = f.read()

new_section = '''        <section id="gift-cart" class="gray-section">
            <div class="container">
                <div class="two-columns">
                    <div class="column">
                        <h1>${HEADING}</h1>
                        <p>${SUBHEADING}</p>
                        <div style="text-align: center; margin-top: 1rem;">
                            <a href="giftcart.html" class="button">Browse &amp; Give</a>
                        </div>
                    </div>
                    <div class="column" style="align-items: center; padding: 2rem;">
                        <a href="giftcart.html">
                            <img src="${IMAGE_PATH}" alt="Gift Cart" style="max-width: 100%; padding: 0.25rem; box-sizing: border-box; border-radius: 12px;">
                        </a>
                    </div>
                </div>
            </div>
        </section>'''

# Find the closing tag of the target section and insert after it
pattern = r'(</section>\s*)(        <section)'
# We need to find the specific section by id and insert after its closing </section>
# Strategy: split on the after_section id, find its closing </section>, insert there

after_id = '${AFTER_SECTION}'
# Find the section opening tag
idx = content.find('id="' + after_id + '"')
if idx == -1:
    idx = content.find("id='" + after_id + "'")

if idx == -1:
    print("  ⚠️  Could not find section id '" + after_id + "' in index.html. Section NOT inserted.")
    print("     Please add it manually.")
else:
    # Find the next </section> after this index
    close_idx = content.find('</section>', idx)
    if close_idx == -1:
        print("  ⚠️  Could not find closing </section> for '" + after_id + "'. Section NOT inserted.")
    else:
        insert_pos = close_idx + len('</section>')
        content = content[:insert_pos] + '\n' + new_section + '\n' + content[insert_pos:]
        with open('index.html', 'w') as f:
            f.write(content)
        print("  ✓ Gift cart section inserted into index.html after #" + after_id + ".")
PYEOF

# ── Step 5: Delete old gift cart section from index.html (if specified) ──
if [ -n "$DELETE_SECTION" ]; then
    echo ""
    echo "▶  Deleting section #${DELETE_SECTION} from index.html..."
    python3 - <<PYEOF
import re

with open('index.html', 'r') as f:
    content = f.read()

delete_id = '${DELETE_SECTION}'
idx = content.find('id="' + delete_id + '"')
if idx == -1:
    idx = content.find("id='" + delete_id + "'")

if idx == -1:
    print("  ⚠️  Could not find section id '" + delete_id + "' — skipping deletion.")
else:
    # Find the start of the <section tag
    start = content.rfind('<section', 0, idx)
    # Find the closing </section> after idx
    end = content.find('</section>', idx)
    if end == -1:
        print("  ⚠️  Could not find closing </section> for '" + delete_id + "' — skipping deletion.")
    else:
        end += len('</section>')
        content = content[:start] + content[end:]
        with open('index.html', 'w') as f:
            f.write(content)
        print("  ✓ Section #" + delete_id + " deleted from index.html.")
PYEOF
fi

# ── Step 6: Auto-alternate gray-section / white on index.html ──
echo ""
echo "▶  Auto-alternating section backgrounds in index.html..."

python3 - <<'PYEOF'
import re

with open('index.html', 'r') as f:
    content = f.read()

# Match all <section ...> opening tags and their positions
section_pattern = re.compile(r'(<section\b[^>]*>)', re.IGNORECASE)
matches = list(section_pattern.finditer(content))

# Determine which sections are "special" — they have an inline background style
# that is not white/default, so we leave them alone
def is_special(tag):
    # Has an inline style with background (color or image)
    if re.search(r'style=["\'][^"\']*background', tag, re.IGNORECASE):
        return True
    return False

# Build the new content by processing matches in reverse (to preserve positions)
replacements = []
gray_turn = False  # hero is white, next eligible section starts white too

for match in matches:
    tag = match.group(1)
    if is_special(tag):
        # Leave special sections untouched, but don't advance the alternation counter
        continue

    # Remove any existing gray-section class from the tag
    new_tag = re.sub(r'\s*class=["\'][^"\']*["\']', '', tag)
    # Remove any leftover background inline style
    new_tag = re.sub(r'\s*style=["\'][^"\']*["\']', '', new_tag)
    # Clean up any double spaces
    new_tag = re.sub(r'  +', ' ', new_tag).strip()
    # Ensure it closes properly
    new_tag = new_tag.rstrip('>').rstrip() + '>'

    if gray_turn:
        # Insert class="gray-section" before the closing >
        new_tag = new_tag[:-1] + ' class="gray-section">'

    replacements.append((match.start(), match.end(), new_tag))
    gray_turn = not gray_turn

# Apply replacements in reverse order to preserve positions
for start, end, new_tag in reversed(replacements):
    content = content[:start] + new_tag + content[end:]

with open('index.html', 'w') as f:
    f.write(content)

print("  ✓ Section backgrounds alternated (special/inline backgrounds preserved).")
PYEOF

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  ✅  All done!"
echo ""
echo "  Files updated:"
echo "  • giftcart.html  (new blank canvas with FundraiseUp gift cart)"
echo "  • index.html     (new gift cart section added)"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
