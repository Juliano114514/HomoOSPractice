
export class StudentData{
  id: string
  name: string
  grade: number

  constructor(id: string, name: string, vote: number) {
    this.id = id
    this.name = name
    this.grade = vote
  }
}