# 应用名称本地化

## 多语言名称

| 语言 | 区域代码 | 应用名称 |
|---|---|---|
| English | `en` | Incense |
| 简体中文 | `zh-Hans` | 云香 |
| 繁体中文 | `zh-Hant` | 雲香 |
| 日本語 | `ja` | 雲香 |
| 한국어 | `ko` | 인센스 |

## 实现方式

每种语言对应 `cloud-incense/{lang}.lproj/InfoPlist.strings`，内容格式：

```
CFBundleDisplayName = "本地化名称";
CFBundleName = "本地化名称";
```

`project.pbxproj` 中的 `knownRegions` 已包含全部区域，构建设置中 `INFOPLIST_KEY_CFBundleDisplayName = Incense` 作为回退值。

## 新增文件列表

```
cloud-incense/
  en.lproj/InfoPlist.strings
  zh-Hans.lproj/InfoPlist.strings
  zh-Hant.lproj/InfoPlist.strings
  ja.lproj/InfoPlist.strings
  ko.lproj/InfoPlist.strings
```

## 添加新语言

1. 在 `cloud-incense/` 下创建 `{lang}.lproj/InfoPlist.strings`
2. 在 `project.pbxproj` 的 `knownRegions` 中添加对应区域代码
