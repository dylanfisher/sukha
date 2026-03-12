# Agent Notes

## Kodi Skin Development

- This repo is a Kodi skin derived from Estuary. Preserve necessary upstream attribution, but treat `Sukha` as the active product name in current metadata, docs, and UI text.
- Primary skin manifest is `addon.xml`. Keep the folder name, add-on id, and manifest aligned as `skin.sukha`.
- For Kodi 21.x Omega compatibility, `addon.xml` should require `xbmc.gui` version `5.17.0` unless there is an intentional version bump.
- Refer to `/docs` for documentation and tips on Kodi skin development.

## Localization

- Maintain `language/resource.language.en_us/strings.po` as the single source of truth for skin strings.
- If Kodi needs other English locale variants, prefer symlink aliases to `en_us` instead of duplicated files.
- Do not leave empty `msgstr` values in the active English locale unless an empty UI label is intentional.
- Prefer non-localized tags in `addon.xml` for basic add-on metadata when only one maintained locale is desired.

## Views And XML Cleanup

- When removing a view from a window, update all of the following together:
  - the window's `<views>` list
  - the window's `<defaultcontrol>` if it points at a removed view
  - the `<include>` entries that instantiate that view inside the window
  - any conditional side panels or overlays that only apply to the removed view ids
- Do not leave dead view files or include registrations behind if they are no longer used.
- If a view XML file is no longer referenced anywhere, remove the file and remove its registration from `xml/Includes.xml`.
- After structural cleanup, search for stale references with `rg` before finishing.

## Testing Loop

- Fastest in-app reload is Kodi built-in `ReloadSkin()`.
- This environment uses an `F5` keymap in Kodi userdata to trigger `ReloadSkin()`.
- Use skin reload for XML/string/layout iteration.
- Restart Kodi when changing `addon.xml`, add-on id/folder identity, compatibility requirements, or when Kodi caches stale state.

## Practical Guardrails

- Prefer deleting obsolete files over keeping unused cruft.
- When simplifying the skin, remove unused assets, views, strings, and include registrations in the same change when practical.
- Before concluding a cleanup change, verify there are no remaining references to removed files, ids, or old branding with `rg`.
