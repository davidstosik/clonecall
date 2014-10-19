module CloneCallJobsHelper

  def link_to_repository repo, opts={}
    begin
      link_to repo.full_name, repo.data.html_url, opts
    rescue Octokit::NotFound
      repo.full_name
    end
  end

end
