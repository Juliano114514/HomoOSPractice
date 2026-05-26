class NameItem {
  name: string
  frequency: number

  constructor(name: string, frequency: number) {
    this.name = name
    this.frequency = frequency
  }
}

/**
 * 基于公安部2020-2025年全国姓名统计数据
 */
export class NameGenerator {
  private static readonly LAST_NAMES: NameItem[] = [
    new NameItem('王', 0.0794), new NameItem('李', 0.0741), new NameItem('张', 0.0707),
    new NameItem('刘', 0.0538), new NameItem('陈', 0.0471), new NameItem('杨', 0.0344),
    new NameItem('黄', 0.0251), new NameItem('赵', 0.0213), new NameItem('吴', 0.0211),
    new NameItem('周', 0.0200), new NameItem('徐', 0.0144), new NameItem('孙', 0.0130),
    new NameItem('马', 0.0126), new NameItem('朱', 0.0121), new NameItem('胡', 0.0117),
    new NameItem('郭', 0.0112), new NameItem('何', 0.0106), new NameItem('高', 0.0101),
    new NameItem('林', 0.0096), new NameItem('罗', 0.0086), new NameItem('郑', 0.0082),
    new NameItem('梁', 0.0078), new NameItem('谢', 0.0072), new NameItem('宋', 0.0068),
    new NameItem('唐', 0.0065), new NameItem('许', 0.0063), new NameItem('韩', 0.0061),
    new NameItem('冯', 0.0059), new NameItem('邓', 0.0056), new NameItem('曹', 0.0055),
    new NameItem('彭', 0.0053), new NameItem('曾', 0.0050), new NameItem('萧', 0.0049),
    new NameItem('田', 0.0048), new NameItem('董', 0.0047), new NameItem('潘', 0.0045),
    new NameItem('袁', 0.0044), new NameItem('蔡', 0.0043), new NameItem('蒋', 0.0042),
    new NameItem('余', 0.0041), new NameItem('于', 0.0040), new NameItem('杜', 0.0039),
    new NameItem('叶', 0.0038), new NameItem('程', 0.0037), new NameItem('苏', 0.0036),
    new NameItem('魏', 0.0035), new NameItem('吕', 0.0034), new NameItem('丁', 0.0033),
    new NameItem('沈', 0.0032), new NameItem('任', 0.0031),
    new NameItem('欧阳', 0.00064), new NameItem('上官', 0.000053), new NameItem('皇甫', 0.000038),
    new NameItem('司徒', 0.000032), new NameItem('诸葛', 0.000026), new NameItem('司马', 0.000020),
    new NameItem('夏侯', 0.000008), new NameItem('尉迟', 0.000005), new NameItem('公孙', 0.000003),
    new NameItem('慕容', 0.000002)
  ]

  private static readonly FIRST_NAMES: NameItem[] = [
    new NameItem('伟', 0.0233), new NameItem('敏', 0.0197), new NameItem('静', 0.0171),
    new NameItem('杰', 0.0167), new NameItem('丽', 0.0163), new NameItem('勇', 0.0147),
    new NameItem('涛', 0.0144), new NameItem('艳', 0.0142), new NameItem('军', 0.0145),
    new NameItem('强', 0.0134), new NameItem('宇', 0.0080), new NameItem('泽', 0.0075),
    new NameItem('轩', 0.0070), new NameItem('浩', 0.0065), new NameItem('博', 0.0060),
    new NameItem('睿', 0.0055), new NameItem('晨', 0.0050), new NameItem('辰', 0.0048),
    new NameItem('涵', 0.0045), new NameItem('翰', 0.0042), new NameItem('欣', 0.0040),
    new NameItem('怡', 0.0038), new NameItem('佳', 0.0036), new NameItem('琪', 0.0034),
    new NameItem('瑶', 0.0032), new NameItem('雨', 0.0030), new NameItem('思', 0.0028),
    new NameItem('彤', 0.0026), new NameItem('萱', 0.0024), new NameItem('馨', 0.0022),
    new NameItem('秀英', 0.0620), new NameItem('桂英', 0.0560), new NameItem('秀兰', 0.0547),
    new NameItem('玉兰', 0.0524), new NameItem('婷婷', 0.0481), new NameItem('建华', 0.0448),
    new NameItem('桂兰', 0.0436), new NameItem('玉梅', 0.0415), new NameItem('秀珍', 0.0406),
    new NameItem('海燕', 0.0292), new NameItem('子轩', 0.0250), new NameItem('雨泽', 0.0240),
    new NameItem('浩宇', 0.0230), new NameItem('博文', 0.0220), new NameItem('睿泽', 0.0210),
    new NameItem('晨曦', 0.0200), new NameItem('梓涵', 0.0190), new NameItem('思远', 0.0180),
    new NameItem('俊豪', 0.0170), new NameItem('明轩', 0.0160), new NameItem('欣怡', 0.0150),
    new NameItem('佳琪', 0.0140), new NameItem('梦瑶', 0.0130), new NameItem('雨桐', 0.0120),
    new NameItem('思彤', 0.0110), new NameItem('雅萱', 0.0100), new NameItem('雨馨', 0.0090),
    new NameItem('梓萱', 0.0080), new NameItem('诗涵', 0.0070), new NameItem('若曦', 0.0060)
  ]

  private static readonly LAST_NAME_PREFIX_SUM: number[] =
    NameGenerator.calculatePrefixSum(NameGenerator.LAST_NAMES)
  private static readonly FIRST_NAME_PREFIX_SUM: number[] =
    NameGenerator.calculatePrefixSum(NameGenerator.FIRST_NAMES)

  private static calculatePrefixSum(items: NameItem[]): number[] {
    const prefixSum: number[] = []
    let sum = 0
    for (let i = 0; i < items.length; i++) {
      sum += items[i].frequency
      prefixSum.push(sum)
    }
    return prefixSum
  }

  private static binarySearchIndex(prefixSum: number[], target: number): number {
    let low = 0
    let high = prefixSum.length - 1
    while (low <= high) {
      const mid = Math.floor((low + high) / 2)
      if (prefixSum[mid] < target) {
        low = mid + 1
      } else if (prefixSum[mid] > target) {
        high = mid - 1
      } else {
        return mid
      }
    }
    return low
  }

  private static weightedRandom(items: NameItem[], prefixSum: number[]): NameItem {
    const randomNow = Math.random() * prefixSum[prefixSum.length - 1]
    let index = NameGenerator.binarySearchIndex(prefixSum, randomNow)
    if (index < 0) {
      index = 0
    }
    if (index >= items.length) {
      index = items.length - 1
    }
    return items[index]
  }

  static generateRandomName(): string {
    const lastName = NameGenerator.weightedRandom(NameGenerator.LAST_NAMES, NameGenerator.LAST_NAME_PREFIX_SUM).name
    const firstName = NameGenerator.weightedRandom(NameGenerator.FIRST_NAMES, NameGenerator.FIRST_NAME_PREFIX_SUM).name
    return `${lastName}${firstName}`
  }

  static generateNames(count: number): string[] {
    if (count < 0) {
      throw new Error('Count must be non-negative')
    }
    const names: string[] = []
    for (let i = 0; i < count; i++) {
      names.push(NameGenerator.generateRandomName())
    }
    return names
  }

  static generateRandomNameItem(): NameItem {
    const lastNameItem = NameGenerator.weightedRandom(NameGenerator.LAST_NAMES, NameGenerator.LAST_NAME_PREFIX_SUM)
    const firstNameItem = NameGenerator.weightedRandom(NameGenerator.FIRST_NAMES, NameGenerator.FIRST_NAME_PREFIX_SUM)
    const combinedFrequency = lastNameItem.frequency * firstNameItem.frequency
    return new NameItem(`${lastNameItem.name}${firstNameItem.name}`, combinedFrequency)
  }
}
