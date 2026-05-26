import { StudentData } from '../model/Models'
import { NameGenerator } from './NameGenerator'

export class StudentGenerator {
  static generateStudents(cnt: number): StudentData[] {
    cnt = (cnt>0) ? cnt : 1
    const students: StudentData[] = []
    for (let i = 0; i < cnt; i++) {
      const id = `S${(i + 1).toString().padStart(4, '0')}`
      const name = NameGenerator.generateRandomName()
      const grade = Math.floor(Math.random() * 750)
      students.push(new StudentData(id, name, grade))
    }
    return students
  }

  static sortByGrade(students: StudentData[]): StudentData[] {
    return [...students].sort((a, b) => b.grade - a.grade);
  }
}
